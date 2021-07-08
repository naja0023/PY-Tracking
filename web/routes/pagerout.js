const router = require('express').Router();
router.get("/", (req, res) => {
    res.render('login') 

})

router.get("/mapping", (req, res) => {
    res.render('index') 

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