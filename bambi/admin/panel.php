<?php
session_start();
if (!isset($_SESSION['logged_in']) || $_SESSION['logged_in'] !== true) {
    header('Location: /bambi/developer/login.php');
    exit;
}

$output = '';
if (isset($_POST['ip'])) {
    $ip = $_POST['ip'];
    // VULNERABLE: directly passing user input to system() without sanitisation.
    // The learner can inject commands using ;, |, &&, etc.
    $cmd = "ping -c 2 " . $ip;
    $output = "<pre>Executing: $cmd\n" . shell_exec($cmd) . "</pre>";
}
?>
<!DOCTYPE html>
<html>
<head><title>Admin Panel - Network Diagnostics</title></head>
<body>
    <h2>Welcome, <?php echo htmlspecialchars($_SESSION['username']); ?>!</h2>
    <h3>Ping a host</h3>
    <form method="POST">
        IP Address: <input type="text" name="ip" placeholder="e.g., 127.0.0.1">
        <input type="submit" value="Ping">
    </form>
    <?php echo $output; ?>
    <hr>
    <p><i>Admin functions – use with care.</i></p>
</body>
</html>