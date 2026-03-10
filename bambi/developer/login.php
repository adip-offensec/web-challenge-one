<?php
session_start();
// Hardcoded credentials for the "dev" user – the password is weak and will be brute‑forced.
$valid_user = 'dev';
$valid_pass_hash = password_hash('password123', PASSWORD_DEFAULT); // In real lab, use a simple hash like md5 for speed? But better to use realistic.

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';
    // For simplicity, we check against a fixed hash. In production, you'd query a DB.
    // We'll use a known weak password: "letmein" or "dev123". Let's pick "devpass".
    // Actually, let's make it easy to brute‑force: password = "admin123" but username is "dev".
    if ($username === 'dev' && $password === 'devpass') {
        $_SESSION['logged_in'] = true;
        $_SESSION['username'] = 'dev';
        header('Location: /bambi/admin/panel.php');
        exit;
    } else {
        $error = "Invalid credentials!";
    }
}
?>
<!DOCTYPE html>
<html>
<head><title>Developer Login</title></head>
<body>
    <h2>Developer Portal Login</h2>
    <?php if (isset($error)) echo "<p style='color:red'>$error</p>"; ?>
    <form method="POST">
        Username: <input type="text" name="username"><br>
        Password: <input type="password" name="password"><br>
        <input type="submit" value="Login">
    </form>
</body>
</html>