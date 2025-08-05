// routes/users.js

import express from 'express';
import jwt from 'jsonwebtoken';
import crypto from 'crypto';
import User from '../models/User.js';
import EmailToken from '../models/EmailToken.js';
import transporter from '../middleware/mailer.js';

const router = express.Router();

import db from '../config/db.js';

// LOGIN
// POST /api/users/login
router.post('/login', async (req, res) => {
    
    try {
        
        const { email, password } = req.body

        // find user by email
        const user = await User.findOne({ email });

        if (!user) {
            return res.status(401).json({ error: 'Email or password invalid' });
        }

        if (!user.verified) {
            return res.status(403).json({ error: 'Email not verified' });
        }

        
        // compare password
        const isMatch = await user.comparePassword(password);

        if (!isMatch) {
            return res.status(401).json({ error: 'Email or password invalid' });
        }


        // create token
        const token = jwt.sign(

            {
                id: user._id,
                username: user.username,
                role: user.role
            },

            process.env.JWT_SECRET,
            { expiresIn: '7d' }

        );


        // send token to client
        res.json({ 

            message: 'Login successful',
            token: token
        
        });




    } catch (error) {
        
        console.error(error);
        res.status(500).json({ error: 'Internal server error during login'});

    }

})

// REGISTRATION
// POST /api/users/register
router.post('/register', async (req, res) => {
    
    try {
        
        const { username, email, password } = req.body;

        const userExists = await User.findOne({ email });

        if (userExists) {
            return res.status(400).json({ message: 'User already exists' });
        }

        const user = new User({ username, email, password, verified: false });
        await user.save();

        // create 32 byte random token
        const token = crypto.randomBytes(32).toString('hex');
        await EmailToken.create({
            userId: user._id,
            token,
            createdAt: Date.now(),
            expiresAt: new Date(Date.now() + 3600000),
        });

        // verification link with token
        const verificationLink = `http://localhost:5000/api/users/verify?token=${token}`; // TODO: change to production link

        // send email
        await transporter.sendMail({
            from: process.env.EMAIL,
            to: email,
            subject: 'Email Verification',
            html: `
                <p>Hello ${username},</p>
                <p>please click the link below to verify your email:</p>
                <a href="${verificationLink}">Verify Email</a>
            `
        });


        res.status(201).json({

            _id: user._id,
            username: user.username,
            email: user.email
            

        })

    } catch (error) {
        
        console.error(error);
        res.status(500).json({ message: 'Error during registration' });

    }

});

// VERIFICATION
// GET /api/users/verify
router.get('/verify', async (req, res) => {

    try {
        
        const { token } = req.query;

        const emailToken = await EmailToken.findOne({ token });

        if (!emailToken) {
            return res.status(400).send('Invalid verification link');
        }

        if (Date.now() > emailToken.expiresAt) {
            return res.status(400).send('Verification link expired');
        }

        // Verify user
        await User.findByIdAndUpdate(emailToken.userId, { verified: true });

        // delete token
        await EmailToken.deleteOne({ token });

        // TODO: redirect to app
        res.send(`
            <html>
            <head><title>Verified</title></head>
            <body>
                <h1>Email verified</h1>
                <p>You can now go back to the app.</p>
                <a href="myapp://login"><button>Open app</button></a>
            </body>
            </html>
        `);

    } catch (error) {
        
        console.error(error);
        res.status(500).json({ message: 'Error during verification' });

    }

});


export default router