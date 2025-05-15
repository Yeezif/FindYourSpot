// models/Spot.js

import mongoose from 'mongoose'

const spotSchema = new mongoose.Schema({

    title: {
        type: String,
        required: true,
    },

    description: String,

    location: {
        type: {
          type: String,
          enum: ['Point'],
          default: 'Point',
        },
        coordinates: {
          type: [Number],
          required: true,
        },
    },

    images: [String],

    tags: [String],

    rating: {
        type: Number,
        default: 0,
    },

    createdAt: {
        type: Date,
        default: Date.now,
    },

    createdBy: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User', // Referenz auf das User-Modell
        required: true,
    },

    comments: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'Comment'
        }
    ],

    upvotes: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User'
        }
    ],

    downvotes: [
        {
            type: mongoose.Schema.Types.ObjectId,
            ref: 'User'
        }
    ]

})

spotSchema.index({ location: '2dsphere' })

const Spot = mongoose.model('Spot', spotSchema)
export default Spot
