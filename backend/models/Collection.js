// models/Collection.js

import mongoose from 'mongoose';

const collectionSchema = new mongoose.Schema({

    title: {
        type: String,
        required: true
    },

    spots: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: "Spot",
        addedAt: {
            type: Date,
            default: Date.now,
        }
    }],

    owner: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
    },

    createdAt: {
        type: Date,
        default: Date.now,
    },

})