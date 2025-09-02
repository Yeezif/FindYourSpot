// routes/users.js

import express from 'express';
import jwt from 'jsonwebtoken';
import crypto from 'crypto';
import User from '../models/User.js';
import EmailToken from '../models/EmailToken.js';
import transporter from '../middleware/mailer.js';
import verifyToken from '../middleware/verifyToken.js';

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

        const emailExists = await User.findOne({ email });
        const usernameExists = await User.findOne({ username });

        if (emailExists) {
            return res.status(400).json({ message: 'Email already in use' });
        }

        if (usernameExists) {
            return res.status(400).json({ message: 'Username already in use' });
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
        const serverUrl = process.env.SERVER_URL;
        const verificationLink = `${serverUrl}/api/users/verify?token=${token}`; 

        // send email
        await transporter.sendMail({
            from: process.env.EMAIL,
            to: email,
            subject: 'Please confirm your email address',
            html: `
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="utf-8">
                <meta name="x-apple-disable-message-reformatting">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <!-- Preheader (hidden preview text) -->
                <div style="display:none;visibility:hidden;opacity:0;color:transparent;height:0;width:0;overflow:hidden;mso-hide:all;">
                Confirm your email address to get started.
                </div>
                <style>
                @media (max-width: 520px) {
                    .container { padding: 24px !important; }
                    .card { padding: 20px !important; }
                    .btn { display:block !important; width:100% !important; }
                }
                @media (prefers-color-scheme: dark) {
                    .wrapper { background: #0b0c0f !important; }
                    .card { background: #111418 !important; border-color: #22262b !important; }
                    .text, .muted, .brand { color: #eaeef2 !important; }
                    .btn { background:#4f8cff !important; color:#ffffff !important; border-color:#4f8cff !important; }
                }
                </style>
            </head>
            <body class="wrapper" style="margin:0;padding:0;background:#f5f7fb;">
                <table role="presentation" width="100%" border="0" cellspacing="0" cellpadding="0" style="background:#f5f7fb;">
                <tr>
                    <td align="center" style="padding:32px 16px;">
                    <table role="presentation" class="container" width="100%" cellpadding="0" cellspacing="0" style="max-width:560px;background:transparent;padding:0;">
                        <tr>
                        <td align="center" style="padding-bottom:16px;">
                            <div class="brand" style="font:600 16px/1.2 -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Ubuntu,'Helvetica Neue',Arial,sans-serif; color:#111827; letter-spacing:.3px;">
                            ${process.env.APP_NAME || 'Your App'}
                            </div>
                        </td>
                        </tr>
                        <tr>
                        <td>
                            <table role="presentation" class="card" width="100%" cellpadding="0" cellspacing="0" 
                                style="background:#ffffff;border:1px solid #e5e7eb;border-radius:14px;padding:28px;box-shadow:0 2px 8px rgba(16,24,40,.06);">
                            <tr>
                                <td>
                                <h1 class="text" style="margin:0 0 10px 0;font:700 20px/1.3 -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Ubuntu,'Helvetica Neue',Arial,sans-serif;color:#111827;">
                                    Verify Your Email
                                </h1>
                                <p class="text" style="margin:0 0 18px 0;font:400 15px/1.6 -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Ubuntu,'Helvetica Neue',Arial,sans-serif;color:#374151;">
                                    Hi ${username},
                                </p>
                                <p class="text" style="margin:0 0 22px 0;font:400 15px/1.6 -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Ubuntu,'Helvetica Neue',Arial,sans-serif;color:#374151;">
                                    Please click the button below to verify your email address.
                                </p>

                                <!-- Button -->
                                <table role="presentation" cellpadding="0" cellspacing="0" border="0" style="margin:0 0 18px 0;">
                                    <tr>
                                    <td>
                                        <a href="${verificationLink}" class="btn"
                                        style="display:inline-block;background:#111827;color:#ffffff;text-decoration:none;
                                                font:600 15px/1 -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Ubuntu,'Helvetica Neue',Arial,sans-serif;
                                                padding:14px 20px;border-radius:10px;border:1px solid #111827;">
                                        Verify Email
                                        </a>
                                    </td>
                                    </tr>
                                </table>

                                <!-- Fallback Link -->
                                <p class="muted" style="margin:0;font:400 12px/1.6 -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Ubuntu,'Helvetica Neue',Arial,sans-serif;color:#6b7280;">
                                    If the button doesn’t work, copy and paste this link into your browser:<br>
                                    <a href="${verificationLink}" style="color:#2563eb;text-decoration:underline;word-break:break-all;">
                                    ${verificationLink}
                                    </a>
                                </p>

                                <!-- Divider -->
                                <hr style="border:none;border-top:1px solid #e5e7eb;margin:24px 0;">

                                <p class="muted" style="margin:0;font:400 12px/1.6 -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Ubuntu,'Helvetica Neue',Arial,sans-serif;color:#6b7280;">
                                    For security reasons, this verification link will expire in 24&nbsp;hours. 
                                    If you did not request this, you can safely ignore this email.
                                </p>
                                </td>
                            </tr>
                            </table>

                            <p class="muted" style="text-align:center;margin:16px 0 0 0;font:400 12px/1.6 -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Ubuntu,'Helvetica Neue',Arial,sans-serif;color:#9ca3af;">
                            © ${new Date().getFullYear()} ${process.env.APP_NAME || 'Your App'}. All rights reserved.
                            </p>
                        </td>
                        </tr>
                    </table>
                    </td>
                </tr>
                </table>
            </body>
            </html>
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
        <!DOCTYPE html>
        <html lang="en">
        <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Email Verified</title>
        <style>
            body {
            margin: 0;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Ubuntu, 'Helvetica Neue', Arial, sans-serif;
            background-color: #f5f7fb;
            color: #111827;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 16px;
            }
            .card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            box-shadow: 0 2px 8px rgba(16, 24, 40, 0.06);
            max-width: 420px;
            width: 100%;
            padding: 28px;
            text-align: center;
            }
            h1 {
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 12px;
            }
            p {
            font-size: 15px;
            line-height: 1.6;
            margin-bottom: 24px;
            color: #374151;
            }
            a {
            text-decoration: none;
            }
            .btn {
            display: inline-block;
            background: #111827;
            color: #ffffff;
            font-weight: 600;
            font-size: 15px;
            padding: 14px 20px;
            border-radius: 10px;
            border: 1px solid #111827;
            transition: background 0.2s ease, transform 0.1s ease;
            }
            .btn:hover {
            background: #1f2937;
            }
            .btn:active {
            transform: scale(0.97);
            }
        </style>
        </head>
        <body>
        <div class="card">
            <h1>Email verified</h1>
            <p>Your email address has been successfully verified. You can now return to the app.</p>
            <a href="myapp://login" class="btn">Open App</a>
        </div>
        </body>
        </html>
        `);

    } catch (error) {
        
        console.error(error);
        res.status(500).json({ message: 'Error during verification' });

    }

});




// GET COLLECTIONS BY USER

// GET /api/users/:userId/collections
router.get('/:userId/collections', verifyToken, async (req, res) => {

    const { userId } = req.params;
    const collections = await User.findById(userId).populate('collections');

    res.json(collections);

});


export default router