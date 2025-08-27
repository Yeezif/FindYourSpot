// middleware/upload.js

import multer from "multer"
import { CloudinaryStorage } from "multer-storage-cloudinary"
import cloudinary from "../config/cloudinary.js"

// Cloudinary-Storage config
const storage = new CloudinaryStorage({

    cloudinary: cloudinary,
    params: {
        folder: 'spots_images',
        allowed_formats: ['jpg', 'png', 'jpeg'],
        transformation: [{ width: 800, crop: "limit", quality: "auto" }]
    }

})

// Multer with Cloudinary
const upload = multer({ storage: storage })

export default upload;