const router = require("express").Router();

const authCheck = (req, res, next) => {
   //if not yet login
   if (!req.user) {
   }
   else {
      next();
   }
}

router.use(authCheck);
// Show profile page
router.get("/userinfo", (req, res) => {
   res.send(req.user)
})

module.exports = router;