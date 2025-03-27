const jwt = require("jsonwebtoken");

const blacklist = new Set(); // Import the blacklist from auth controller

exports.authenticate = (req, res, next) => {
  const authHeader = req.header("Authorization");
  
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ message: "Unauthorized: No token provided" });
  }

  try {
    const token = authHeader.split(" ")[1];

    // ✅ Check if the token is blacklisted
    if (blacklist.has(token)) {
      return res.status(401).json({ message: "Token is invalid or logged out" });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded; // Attach user info to request
    next();
  } catch (error) {
    return res.status(401).json({ message: "Invalid token" });
  }
};
