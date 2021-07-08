const router = require('express').Router();
const path = require("path");
router.get("/", (req, res) => {
    res.render('login') 

})

router.get("/mapping", (req, res) => {
    res.sendFile(path.join(__dirname, "../views/index.html"));

})
router.get("/register", (req, res) => {
    res.render('register') 

})

router.get("/manage", (req, res) => {
    res.render('manageuser') 

})

router.get("/admin", (req, res) => {
    res.render('admin') 

})

module.exports = router;