// config/cloudinary.js

import cloudinary from 'cloudinary'
import dotenv from 'dotenv'

// load env
dotenv.config()

// config cloudinary
cloudinary.config({

    cloud_name: process.env.CLOUDINARY_CLOUD_NAME,
    api_key: process.env.CLOUDINARY_API_KEY,
    api_secret: process.env.CLOUDINARY_API_SECRET

})

export default cloudinary