const router = require('express').Router();
const path = require("path");
var mqtt = require('mqtt');
const { appendFile } = require('fs');
const checkUser = require('./middleware');
//  router.use(checkUser);

var client = mqtt.connect('mqtt://broker.emqx.io')

router.get("/", (req, res) => {
    res.render('login')

})

router.get("/mapping", (req, res) => {
    client.on('connect', function() {
        client.subscribe('moyanyo', function(err) {
            if (!err) {
                client.publish('moyanyo', 'Hello mqtt')
            }
        })
    })



    client.on('message', function(topic, message) {
        // message is Buffer
        console.log(message.toString())
            // client.end()
    })
    res.render('index')

})
router.get("/register", checkUser, (req, res) => {
    res.render('register')

})

router.get("/check", checkUser, (req, res) => {
    res.render('checkpage')

})

// router.get("/admin", checkUser, (req, res) => {
//     res.render('manageuser')

// })

router.get("/profile", (req, res) => {
    res.render('profile')

})

router.get("/driver", checkUser, (req, res) => {
    res.render('driver')

})
router.get("/car", (req, res) => {
    res.render('car')

})
router.get("/match", checkUser, (req, res) => {
    res.render('match')

})
router.get("/dashboard", checkUser, (req, res) => {
    res.render('dashboard')

})

router.get("/review", checkUser, (req, res) => {
    res.render('review')

})

router.get("/heatmap", checkUser, (req, res) => {
    res.render('heatmap')

})
router.get("/requestdata", checkUser, (req, res) => {
    res.render('requestdata')

})
module.exports = router;