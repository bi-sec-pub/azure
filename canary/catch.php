<?php
// send-mail-for-incoming-token
// bi-sec 2023-11
// change the *changeme* parts 

// Trim alerts
if (!isset($_GET['t'])) die;
if (strlen($_GET['t']) > 36 || strlen($_GET['t']) < 36) die;

?>

<?php
// Includes for: https://github.com/PHPMailer/PHPMailer/releases
        use PHPMailer\PHPMailer\PHPMailer;
        use PHPMailer\PHPMailer\Exception;

        require 'PHPMailer/src/Exception.php';
        require 'PHPMailer/src/PHPMailer.php';
        require 'PHPMailer/src/SMTP.php';
?>


<?php
$mailusername = "*changeme*";
$mailpassword = "*changeme*";

// Get E-Mail-User

$mailSender = "*changeme*";
$mailTopic = "[Alert] Canary activated: " . htmlentities($_GET['t']);
$mailBody = "Hi, <br /> <br /> there was an alert for Token: <br />" . htmlentities($_GET['t']);


        $mail = new PHPMailer(true);                              // Passing `true` enables exceptions
        try {
                //Server settings
                $mail->SMTPDebug = 0;                                 // Enable verbose debug output
                $mail->isSMTP();                                      // Set mailer to use SMTP
                $mail->Host = 'outlook.office365.com';  // Specify main and backup SMTP servers
                $mail->SMTPAuth = true;                               // Enable SMTP authentication
                $mail->Username = $mailusername;                 // SMTP username
                $mail->Password = $mailpassword;                           // SMTP password
                $mail->SMTPSecure = 'tls';                            // Enable TLS encryption, `ssl` also accepted
                $mail->Port = 587;                                    // TCP port to connect to

                //Recipients
                $mail->setFrom($mailSender, '*changeme*');
                $mail->addAddress('*changeme*');     // Add a recipient            // Name is optional

                //Content
                $mail->isHTML(true);                                  // Set email format to HTML

                $mail->Subject = $mailTopic;
                $mail->Body    = $mailBody;

                $mail->send();
#                echo 'Message has been sent';
        } catch (Exception $e) {
		}
		
?> 
