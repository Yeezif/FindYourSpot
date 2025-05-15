// middleware/upload.js

import multer from "multer"
import { CloudinaryStorage } from "multer-storage-cloudinary"
import cloudinary from "../config/cloudinary.js"

// Cloudinary-Storage config
const storage = new CloudinaryStorage({

    cloudinary: cloudinary,
    params: {
        folder: 'spots',
        allowed_formats: ['jpg', 'png', 'jpeg']
    }

})

// Multer with Cloudinary
const upload = multer({ storage: storage })

export default upload;