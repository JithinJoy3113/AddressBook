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
        <cfset obj = new Components.addressbook()>
        <div class="bodyContent d-flex flex-column">
            <div class="headerDiv d-flex justify-content-between align-items-center">
                <div class="logoDiv">
                    <img src="https://toddbrentlinger.github.io/odin-project/intermediate-html-and-css/grid/project-admin-dashboard/favicon/android-chrome-192x192.png"
                        alt="Project Admin Dashboard icon" width="42px" height="42px">
                    <span class="headerName text-white">ADDRESS BOOK</span>
                </div>
                <div class="headerButtonsDiv d-flex">
                    <div class="signInDiv d-flex">
                        <a href="signUp.cfm" class="text-decoration-none text-white">
                            <img src="assets/images/login.png" alt="" width="14px" height="14px">
                            <a href="index.cfm" class="signInKink text-white text-decoration-none ms-1">Login</a>
                        </a>
                    </div>
                </div>
            </div>
            <form action="" method="post"  enctype="multipart/form-data">
                <div class="contentDiv d-flex justify-content-center align-items-center">
                    <div class="loginContentDiv d-flex ">
                        <div class="loginLeftDiv d-flex align-items-center justify-content-between">
                            <img src="https://toddbrentlinger.github.io/odin-project/intermediate-html-and-css/grid/project-admin-dashboard/favicon/android-chrome-192x192.png"
                            alt="Project Admin Dashboard icon" width="100px" height="100px">
                        </div>
                        <div class="loginRight d-flex flex-column align-items-center">
                            <span class="loginHead">SIGN UP</span>
                            <div class="formDiv d-flex flex-column">
                                <input type="text" class="inputFieldSignup" name="fullNameInput" id="fullNameInput" placeholder="Fullname">
                                <span class="errorMessage" id="nameError"></span>
                                <input type="text" class="inputFieldSignup" name="emailInput" id="emailInput" placeholder="Email ID">
                                <span class="errorMessage" id="emailError"></span>
                                <input type="text" class="inputFieldSignup" name="userNameInput" id="userNameInput" placeholder="Username">
                                <span class="errorMessage" id="userNameError"></span>
                                <input type="text" class="inputFieldSignup" name="passwordInput" id="passwordInput" placeholder="Password">
                                <span class="errorMessage" id="passwordError"></span>
                                <input type="text" class="inputFieldSignup" id="confirmInput" placeholder="Confirm Password">
                                <span class="errorMessage" id="confirmError"></span>
                                <div class="buttonWrap">
                                    <label class ="newButton ms-1" for="upload">Upload Image:<br>
                                    <input id="uploadProfile" name="uploadProfile" type="file" class="signUpImage mt-2">
                                </div>
                                <div class="regButtonDiv mx-auto">
                                    <button type="submit" class="loginButton" id="loginBtuuon" name="userSignUp" onclick="return signUpValidate()">Register</button>
                                </div>    
                            </div>
                            <span class="loginCreate mt-3">Alerady have account? 
                                <a href="index.cfm" class="text-decoration-none">Login</a>
                            </span>
                        </div>
                    </div>
                </div>
            </form>
            <cfif structKeyExists(form, "userSignUp")>
                <cfset result = obj.userSignUp(form.fullNameInput,form.emailInput,form.userNameInput,form.passwordInput,form.uploadProfile)>
                <cfif result>
                    <span class="text-success fw-bold mx-auto">User Registration Success</span>
                <cfelse>
                    <span class="text-danger fw-bold mx-auto">Email Already exist</span>
                </cfif>
            </cfif>
        </div>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <script src="js/script.js"></script>
    </body>
</html>