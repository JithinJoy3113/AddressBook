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
        <cfoutput>
            <form action="" method="post" enctype="multipart/form-data">
                <cfif structKeyExists(form,"alertBtn")>
                    <cflocation  url="index.cfm" addToken = "no">
                </cfif>
                <div class="bodyContent d-flex flex-column">
                    <div class="headerDiv d-flex justify-content-between align-items-center">
                        <div class="logoDiv">
                            <img src="https://toddbrentlinger.github.io/odin-project/intermediate-html-and-css/grid/project-admin-dashboard/favicon/android-chrome-192x192.png"
                                alt="Project Admin Dashboard icon" width="42px" height="42px">
                            <span class="headerName text-white">ADDRESS BOOK</span>
                        </div>
                        <div class="headerButtonsDiv d-flex">
                            <div class="signInDiv d-flex">
                                <button type="button" class="logoutButton text-white border-0" onclick="logoutValidate()">
                                    <img src="assets/images/login.png" alt="" width="14px" height="14px" class="me-1">Logout
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="userContentDiv d-flex align-items-center justify-content-center" id="contentDiv">
                        <div class="bodyContents w-100 " id="bodyContents">
                            <div class="fileHeader d-flex justify-content-end">
                                <div class="fileButtons">
                                    <button type="button" class="pdfButton border-0">
                                        <img src="assets/images/pdf (1).png" class="fileImage mx-1" width="32px" height="32px">
                                    </button>
                                    <button type="button" class="pdfButton border-0">
                                        <img src="assets/images/excel.png"  class="fileImage mx-1" alt="" width="32px" height="32px">
                                    </button>
                                    <button type="button" class="pdfButton border-0">
                                        <img src="assets/images/printer.png"  class="fileImage mx-1" alt="" width="32px" height="32px">
                                    </button>                    
                                </div>
                            </div>
                            <div class="userDetailsDiv d-flex mt-3 w-100">
                                <div class="userProfileDiv d-flex flex-column align-items-center">
                                    <div class="userProfile">
                                        <img src="assets/uploadImages/#session.userDetails.image#" alt="" width="100px" height="100px">
                                    </div>
                                    <span class="profileName mt-2">#session.userDetails.fullName#</span>
                                    <button type="button" class="createContactButton mt-4 mb-2" onclick="createContact()">CREATE CONTACT</button>
                                </div>
                                <div class="userContactsDiv d-flex flex-column ms-3">
                                    <div class="contactTableHead d-flex">
                                        <span class="nameHead">NAME</span>
                                        <span class="emailHead">EMAIL ID</span>
                                        <span class="phoneHead">PHONE NUMBER</span>
                                    </div>
                                    <div class="ContactsDetailsDiv d-flex flex-column">
                                        <div class="detailsRow d-flex align-items-center  py-3">
                                            <div class="detailsDiv d-flex align-items-center">
                                                <img src="assets/images/defaultProfile.jpg" alt="" width="70px" height="70px">
                                                <div class="nameSpan detailsFont ms-3">Jithin</div>
                                                <div class="emailSpan detailsFont">jithinj3113@gmail.com</div>
                                                <div class="phoneSpan detailsFont">1234567898</div>
                                            </div>
                                            <div class="detailsButtonDiv d-flex">
                                                <div class="editButtonDiv">
                                                    <button class="editButton" type="button" onclick="editContact()">EDIT</button>
                                                </div>
                                                <div class="editButtonDiv">
                                                    <button class="editButton" type="button" onclick="deleteButton()">DELETE</button>
                                                </div>
                                                <div class="editButtonDiv">
                                                    <button class="editButton" type="button" onclick="viewContact()">VIEW</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>  

                        <!-- create / edit -->
                        <div class="showContactDiv" id="createEditDiv">
                            <div class="showContactDetails d-flex flex-column">
                                <div class="showContactHead" id="showContactHead"></div>
                                <div class="showContactInfoDiv d-flex flex-column mt-4 pt-1 pe-4">
                                    <span class="personalDetails" id="personalDetails">Personal Details</span>
                                    <div class="nameInputDiv d-flex mt-3">
                                        <div class="inputDiv d-flex flex-column">
                                            <label for="name" class="nameLabel" id="titleLabel">Title *</label>
                                            <select name="titleSelect" class="titleSelect inputBorder mt-3" id="titleSelect">'
                                                <option value=""></option>
                                                <option value="Mr">Mr</option>
                                                <option value="Mrs">Miss</option>
                                            </select>
                                        </div>
                                        <div class="inputDiv d-flex flex-column ms-4 ps-1">
                                            <label for="name" class="nameLabel" id="firstNameLabel">First Name *</label>
                                            <input type="text" class="firstNameInput inputBorder mt-3" id="firstNameInput" placeholder="Your First Name">
                                        </div>
                                        <div class="inputDiv d-flex flex-column ms-4 ps-1">
                                            <label for="name" class="nameLabel" id="lastNameLabel">Last Name *</label>
                                            <input type="text" class="lastNameInput inputBorder mt-3" id="lastNameInput" placeholder="Your Last Name">
                                        </div>
                                    </div>
                                    <div class="genderMainDiv d-flex mt-3 justify-content-between">
                                        <div class="genderDiv d-flex flex-column">
                                            <label for="name" class="nameLabel" id="genderLabel">Gender *</label>
                                            <select name="gender" id="genderSelect" class="genderSelect inputBorder mt-3">
                                                <option value=""></option>
                                                <option value="Male" id="gender">Male</option>
                                                <option value="Female" id="gender">Female</option>
                                            </select>
                                        </div>
                                        <div class="dobDiv d-flex flex-column">
                                            <label for="name" class="nameLabel" id="dobLabel">Date of Birth *</label>
                                            <input type="date" class="inputBorder dateInput mt-3" id="dateInput">
                                        </div>
                                    </div>
                                    <div class="createUpload d-flex flex-column mt-3">
                                        <label for="name" class="nameLabel">Upload Photo</label>
                                        <input id="uploadProfile" type="file" class="signUpImage mt-2">
                                    </div>
                                    <span class="errorMessage" id="createErrorMessage"></span>
                                    <span class="personalDetails mt-4">Contact Details</span>
                                    <div class="addressMainDiv d-flex justify-content-between">
                                        <div class="addressDiv d-flex flex-column">
                                            <label for="address" class="nameLabel mt-3" id="addressLabel">Address *</label>
                                            <input type="text" class="inputBorder mt-3" id="addressInput" placeholder="Your Address">
                                        </div>
                                        <div class="addressDiv d-flex flex-column">
                                            <label for="street" class="nameLabel mt-3" id="streetLabel">Street *</label>
                                            <input type="text" class="inputBorder mt-3" id="streetInput" placeholder="Your Street Name">
                                        </div>
                                    </div>
                                    <div class="locationDiv d-flex justify-content-between">
                                        <div class="districtDiv addressDiv">
                                            <label for="district" class="nameLabel mt-3" id="districtLabel">District *</label>
                                            <input type="text" id="districtSelect" class="addressDiv inputBorder">
                                        </div>
                                        <div class="stateDiv addressDiv">
                                            <label for="state" class="nameLabel mt-3" id="stateLabel">State *</label>
                                            <input type="text" id="stateSelect" class="inputBorder addressDiv">
                                        </div>
                                    </div>
                                    <div class="pincodeMainDiv d-flex justify-content-between">
                                        <div class="countryDiv addressDiv">
                                            <label for="country" class="nameLabel mt-3" id="countryLabel">Country *</label>
                                            <input type="text" id="countrySelect" class="addressDiv inputBorder">
                                        </div>
                                        <div class="pincodeDiv addressDiv">
                                            <label for="pincode" class="nameLabel mt-3" id="pincodeLabel">Pincode *</label>
                                            <input type="text" id="pincode" class="inputBorder addressDiv" placeholder="Your Pincode">
                                        </div>
                                    </div>
                                    <div class="emailMainDiv d-flex justify-content-between">
                                        <div class="emailDiv addressDiv">
                                            <label for="email" class="nameLabel mt-3" id="emailLabel">Email*</label>
                                            <input type="text" name="email" id="emailInput" class="inputBorder addressDiv" placeholder="Your Email Id">
                                        </div>
                                        <div class="mobileDiv addressDiv">
                                            <label for="mobile" class="nameLabel mt-3" id="mobileLabel">Mobile *</label>
                                            <input type="text" id="mobile" class="inputBorder addressDiv" placeholder="Your Number">
                                        </div>
                                    </div>
                                </div>
                                <span class="errorMessage" id="createErrorMessageTwo"></span>
                                <div class="crateDetailButtonDiv d-flex justify-content-center py-3">
                                    <button type="button" class="createDetailButton" id="createDetailButton" onclick="return createContactSumbit()">Create</button>
                                    <button type="button" class="editDetailButton" id="editDetailButton" onclick="editContactSumbit()">Update</button>
                                </div>
                            </div>
                            <div class="showContactImage d-flex flex-column">
                                <div class="createCloseDiv d-flex justify-content-end">
                                    <button type="button" class="createClose border-0" onclick="createClose()"><img width="35" height="35" src="https://img.icons8.com/sf-regular/48/387cb4/close-window.png" alt="close-window"/></button>
                                </div>
                                <div class="createProfileImage px-4 py-3">
                                    <img src="assets/images/defaultProfile.jpg" alt="" width="110px" height="110px" class="mt-5 mx-2">
                                </div>
                            </div>
                        </div> 
                    

                        <!-- view Contact details -->

                        <div class="showContactDiv" id="showContactDiv">
                            <div class="showContactDetails d-flex flex-column">
                                <div class="showContactHead">
                                    CONTACT DETAILS
                                </div>
                                <div class="showContactInfoDiv d-flex flex-column mt-4 pt-1">
                                    <div class="contactNameDiv d-flex">
                                        <div class="contactLabel text-capitalize">name</div>
                                        <div class="contactSymbol">:</div>
                                        <div class="contactName ms-4">Jithin Joy</div>
                                    </div>
                                    <div class="contactNameDiv d-flex">
                                        <div class="contactLabel text-capitalize">name</div>
                                        <div class="contactSymbol">:</div>
                                        <div class="contactName ms-4">Jithin Joy</div>
                                    </div>
                                    <div class="contactNameDiv d-flex">
                                        <div class="contactLabel text-capitalize">name</div>
                                        <div class="contactSymbol">:</div>
                                        <div class="contactName ms-4">Jithin Joy</div>
                                    </div>
                                    <div class="contactNameDiv d-flex">
                                        <div class="contactLabel text-capitalize">name</div>
                                        <div class="contactSymbol">:</div>
                                        <div class="contactName ms-4">Jithin Joy</div>
                                    </div>
                                    <div class="contactNameDiv d-flex">
                                        <div class="contactLabel text-capitalize">name</div>
                                        <div class="contactSymbol">:</div>
                                        <div class="contactName ms-4">esssssssssssssgtrgsbdvsertgbhsdfhbsdrtsegbdfxbvxbsd</div>
                                    </div>
                                    <div class="contactNameDiv d-flex">
                                        <div class="contactLabel text-capitalize">name</div>
                                        <div class="contactSymbol">:</div>
                                        <div class="contactName ms-4">Jithin Joy</div>
                                    </div>
                                </div>
                                <div class="crateDetailButtonDiv d-flex justify-content-center py-3">
                                    <button type="button" class="createDetailButton" id="crateDetailButton" onclick="viewContactClose()">CLOSE</button>
                                </div>
                            </div>
                            <div class="showContactImage d-flex px-4 py-5">
                                <img src="assets/images/defaultProfile.jpg" alt="" width="110px" height="110px" class="mt-5">
                            </div>
                        </div> 

                        <!-- delete contact -->

                        <div class="deleteConfirm" id="deleteConfirm">
                            <span class="logourtAlertHead py-2 d-flex justify-content-center fw-bold text-white">Delete Page</span>
                            <div class="logoutMesage  d-flex flex-column justify-content-center">
                                <span class="confirmMessage fw-bold">Are you sure want to Delete?</span>
                                <button class="alertBtn mt-3" type="submit" name="alertDeleteBtn" id="alertDeleteBtn" onClick="return deleteAlert('yes')">Delete</button>
                                <button class="alertCancelBtn mt-2" type="sumbit" name="alertDeleteBtn" id="alertDeleteBtn" onClick="return deleteAlert('no')">Cancel</button>
                            </div>
                        </div> 
                        
                        <!-- User logout -->

                        <div class="logoutConfirm" id="logoutConfirm">
                            <span class="logourtAlertHead py-2 d-flex justify-content-center fw-bold text-white">Logout Alert</span>
                            <div class="logoutMesage  d-flex flex-column justify-content-center">
                                <span class="confirmMessage fw-bold">Are you sure want to logout?</span>
                                <button class="alertBtn mt-3" type="submit" name="alertBtn" id="alertBtn" onClick="return logoutAlert('yes')">Logout</button>
                                <button class="alertCancelBtn mt-2" type="submit" name="alertBtn" id="alertBtn" onClick="return logoutAlert('no')">Cancel</button>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
            <script src="js/script.js"></script>
        </cfoutput>
    </body>
</html>