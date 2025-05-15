// models/Comment.js

import mongoose from 'mongoose'
import Spot from './Spot.js'

const commentSchema = new mongoose.Schema({

    text: {
        type: String,
        required: true
    },

    createdAt: {
        type: Date,
        default: Date.now
    },

    createdBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },

    spot: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Spot',
        required: true
    }

})

const Comment = mongoose.model('Comment', commentSchema)

export default Comment