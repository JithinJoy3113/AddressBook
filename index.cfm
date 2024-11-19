<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login</title>
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body>
        <div class="bodyContent d-flex flex-column">
            <form method="post" action="">
                <div class="headerDiv d-flex justify-content-between align-items-center">
                    <div class="logoDiv">
                        <img src="https://toddbrentlinger.github.io/odin-project/intermediate-html-and-css/grid/project-admin-dashboard/favicon/android-chrome-192x192.png"
                            alt="Project Admin Dashboard icon" width="42px" height="42px">
                        <span class="headerName text-white">ADDRESS BOOK</span>
                    </div>
                    <div class="headerButtonsDiv d-flex">
                        <div class="signInDiv d-flex">
                            <a href="signUp.cfm" class="text-decoration-none text-white">
                                <img src="assets/images/signin.PNG" alt="" width="14px" height="14px">
                                <span class="signInKink text-white">Sign Up</span>
                            </a>
                        </div>
                    </div>
                </div>
                <div class="contentDiv d-flex justify-content-center align-items-center">
                    <div class="loginContentDiv d-flex ">
                        <div class="loginLeftDiv d-flex align-items-center justify-content-between">
                            <img src="https://toddbrentlinger.github.io/odin-project/intermediate-html-and-css/grid/project-admin-dashboard/favicon/android-chrome-192x192.png"
                            alt="Project Admin Dashboard icon" width="100px" height="100px">
                        </div>
                        <div class="loginRight d-flex flex-column align-items-center">
                            <span class="loginHead">LOGIN</span>
                            <div class="formDiv d-flex flex-column">
                                <input type="text" class="inputField" name="userNameInput" id="userNameInput" placeholder="Username">
                                <span class="errorMessage" id="emailError"></span>
                                <input type="text" class="inputField" name="passwordInput" id="passwordInput" placeholder="Password">
                                <span class="errorMessage" id="passwordError"></span>
                                <div class="buttonDiv mx-auto">
                                    <button type="submit" class="loginButton" name="loginButton" id="loginBtuuon" onclick="return loginValidation()">LOGIN</button>
                                </div>    
                                <span class="loginSignup mx-auto mt-4">Or Sign In Using</span>
                            </div>
                            <div class="socialLogo d-flex mt-3">
                                <div class="fbLogo mx-2">
                                    <a href="">
                                        <img src="assets/images/facebook.png" alt="" width="55" height="55">
                                    </a>
                                </div>
                                <div class="fbLogo mx-2">
                                    <a href="">
                                        <img src="assets/images/google.jpg" alt="" width="55" height="55">
                                    </a>
                                </div>
                            </div>
                            <span class="loginCreate mt-3">Don't have an account? 
                                <a href="signup.cfm" class="text-decoration-none">Register Here</a>
                            </span>
                        </div>
                    </div>
                </div>
            </form>
            <cfif structKeyExists(form, "loginButton")>
                <cfset local.obj = new components.component()>
                <cfset local.result = local.obj.userLogin(form.userNameInput,form.passwordInput)>
                <cfif local.result>
                    <cflocation  url="userHome.cfm">
                <cfelse>
                    <span class="fw-bold text-danger mx-auto">Invalid user login<span>
                </cfif>
            </cfif>
        </div>
        <script src="js/script.js"></script>
    </body>
</html>