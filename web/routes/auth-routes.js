const router = require('express').Router()
const passport = require('passport')
const mysql = require('mysql')
const jwt = require('jsonwebtoken')
require('dotenv').config()
const config = require('../config/dbConfig')
const con = mysql.createConnection(config)

//login using Google
router.get(
  '/google',
  passport.authenticate('google', { scope: ['profile', 'email'] }),
)

//if login success, redirect here
router.get('/google/redirect', (req, res) => {
  console.log(req.user)
  const payload = {
    email: 'user',
    photo: 'user',
    name: 'user',
  }
  const token = jwt.sign(payload, process.env.JWT_KEY, { expiresIn: '1d' })
  const cookieOption = {
    maxAge: 24 * 60 * 60 * 1000, //ms
    httpOnly: true,
    signed: true,
  }
  res.cookie('mytoken', token, cookieOption)
  res.redirect('/mapping')
})

//log out
router.get('/logout', (req, res) => {
  req.logOut()
  // var removing = browser.cookies.remove()
  res.clearCookie('mytoken')

  res.redirect('/')
})

module.exports = router
