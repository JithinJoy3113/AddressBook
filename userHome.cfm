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
            <cfset local.obj = new Components.addressbook()>
            <cfset local.pdf = application.obj.getPdf()>
            <form action="" method="post" enctype="multipart/form-data" id="fromId">
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
                            <div class="fileHeader d-flex justify-content-between">
                                <cfif structKeyExists(form, "createDetailButton")>
                                    <cfset local.result = local.obj.createContact(form.titleSelect,form.firstNameInput,form.lastNameInput,form.genderSelect, form.dateInput,form.uploadProfile,form.addressInput,form.streetInput,form.districtInput,form.stateInput,form.countryInput,form.pincode,form.email,form.mobile)>
                                    <cfif local.result>
                                        <span class="fw-bold text-success">Contact added Succesfully</span>
                                    <cfelse>
                                        <span class="fw-bold text-danger">Contact already exist</span>
                                    </cfif>
                                </cfif>
                                <cfif structKeyExists(form, "editDetailButton")>
                                    <cfset local.result = local.obj.updateContact(form.titleSelect,form.firstNameInput,form.lastNameInput,form.genderSelect,form.dateInput,form.uploadProfile,form.addressInput,form.streetInput,form.districtInput,form.stateInput,form.countryInput,form.pincode,form.email,form.mobile)>
                                    <cfif local.result>
                                       <span class="fw-bold text-success">Contact updated Succesfully</span>
                                    <cfelse>
                                        <span class="fw-bold text-danger">Contact already exist</span>
                                    </cfif>
                                </cfif>
                                <div class="fileButtons ms-auto">
                                    <a href="assets/pdfs/addressBookcontacts.pdf" download = "ReportPDF" class="text-decoration-none" name="pdfButton">
                                        <img src="assets/images/pdf (1).png" class="fileImage mx-1" width="32px" height="32px">
                                    </a>
                                    <a href="assets/spreadSheets/addressBookcontacts.xlsx" class="text-decoration-none" download = "ReportSheet" name="excelButtonon" onclick="getExcel()">
                                        <img src="assets/images/excel.png"  class="fileImage mx-1" alt="" width="32px" height="32px">
                                    </a>
                                    <a href="" onclick="printContacts()" class="text-decoration-none">
                                        <img src="assets/images/printer.png"  class="fileImage mx-1" alt="" width="32px" height="32px">
                                    </a>                  
                                </div>
                            </div>
                            <div class="userDetailsDiv d-flex mt-3 w-100">
                                <div class="userProfileDiv d-flex flex-column align-items-center">
                                    <div class="userProfile">
                                        <img src="assets/uploadImages/#session.userDetails.image#" alt="" width="100px" height="100px" class="rounded-circle">
                                    </div>
                                    <span class="profileName mt-2">#session.userDetails.fullName#</span>
                                    <button type="button" class="createContactButton mt-4 mb-2" onclick="createContact()">CREATE CONTACT</button>
                                </div>
                                <cfset local.result = local.obj.contactListView()>
                                <cfif local.result.len()>
                                    <div class="userContactsDiv d-flex flex-column ms-3" id="userContactsDiv">
                                        <div class="contactTableHead d-flex">
                                            <span class="nameHead">NAME</span>
                                            <span class="emailHead">EMAIL ID</span>
                                            <span class="phoneHead">PHONE NUMBER</span>
                                        </div>
                                        <div class="ContactsDetailsDiv d-flex flex-column">
                                                <cfloop query="#local.result#">
                                                    <div class="detailsRow d-flex align-items-center  py-3">
                                                        <div class="detailsDiv d-flex align-items-center">
                                                            <img src="assets/uploadImages/#Profile#" alt="" width="70px" height="70px" class="rounded-circle">
                                                            <div class="nameSpan detailsFont ms-3">#FirstName# #LastName#</div>
                                                            <div class="emailSpan detailsFont">#Email#</div>
                                                            <div class="phoneSpan detailsFont">#Mobile#</div>
                                                        </div>
                                                        <div class="detailsButtonDiv d-flex">
                                                            <div class="editButtonDiv">
                                                                <button class="editButton" type="button" onclick="editContact(this)" id="editButtonId" value="#ID#">EDIT</button>
                                                            </div>
                                                            <div class="editButtonDiv">
                                                                <button class="editButton" type="button" onclick="deleteButton(this)" id="deleteButtonId" value="#ID#">DELETE</button>
                                                            </div>
                                                            <div class="editButtonDiv">
                                                                <button class="editButton" type="button" onclick="viewContact(this)" id="viewButtonId" value="#ID#">VIEW</button>
                                                            </div>
                                                        </div><br>
                                                    </div>
                                                </cfloop> 
                                        </div>
                                    </div>
                                <cfelse>
                                    <div class="userContactsErrorDiv ms-3 d-flex justify-content-center align-items-center ">
                                        <span class="noRecords mx-auto my-5">No Contacts</span>
                                    </div>
                                </cfif>
                            </div>
                        </div>  

                        <!-- create / edit -->

                        <div class="showContactDiv" id="createEditDiv">
                            <div class="showContactDetails d-flex flex-column">
                                <div class="showContactHead" id="showContactHead"></div>
                                <div class="showContactInfoDiv d-flex flex-column mt-4 pt-1 pe-4" id="showContactInfoDiv">
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
                                            <input type="text" class="firstNameInput inputBorder mt-3" name="firstNameInput" id="firstNameInput" placeholder="Your First Name">
                                        </div>
                                        <div class="inputDiv d-flex flex-column ms-4 ps-1">
                                            <label for="name" class="nameLabel" id="lastNameLabel">Last Name *</label>
                                            <input type="text" class="lastNameInput inputBorder mt-3" id="lastNameInput" name="lastNameInput" placeholder="Your Last Name">
                                        </div>
                                    </div>
                                    <div class="genderMainDiv d-flex mt-3 justify-content-between">
                                        <div class="genderDiv d-flex flex-column">
                                            <label for="name" class="nameLabel" id="genderLabel">Gender *</label>
                                            <select id="genderSelect" name="genderSelect" class="genderSelect inputBorder mt-3">
                                                <option value=""></option>
                                                <option value="Male" id="gender">Male</option>
                                                <option value="Female" id="gender">Female</option>
                                            </select>
                                        </div>
                                        <div class="dobDiv d-flex flex-column">
                                            <label for="name" class="nameLabel" id="dobLabel">Date of Birth *</label>
                                            <input type="date" class="inputBorder dateInput mt-3" id="dateInputField" name="dateInput">
                                        </div>
                                    </div>
                                    <div class="createUpload d-flex flex-column mt-3">
                                        <label for="name" class="nameLabel">Upload Photo</label>
                                        <input id="uploadProfile" type="file" class="signUpImage mt-2" name="uploadProfile">
                                    </div>
                                    <span class="errorMessage" id="createErrorMessage"></span>
                                    <span class="personalDetails mt-4">Contact Details</span>
                                    <div class="addressMainDiv d-flex justify-content-between">
                                        <div class="addressDiv d-flex flex-column">
                                            <label for="address" class="nameLabel mt-3" id="addressLabel">Address *</label>
                                            <input type="text" class="inputBorder mt-3" id="addressInput" name="addressInput" placeholder="Your Address">
                                        </div>
                                        <div class="addressDiv d-flex flex-column">
                                            <label for="street" class="nameLabel mt-3" id="streetLabel">Street *</label>
                                            <input type="text" class="inputBorder mt-3" id="streetInput" name="streetInput" placeholder="Your Street Name">
                                        </div>
                                    </div>
                                    <div class="locationDiv d-flex justify-content-between">
                                        <div class="districtDiv addressDiv">
                                            <label for="district" class="nameLabel mt-3" id="districtLabel">District *</label>
                                            <input type="text" id="districtSelect" class="addressDiv inputBorder" name="districtInput">
                                        </div>
                                        <div class="stateDiv addressDiv">
                                            <label for="state" class="nameLabel mt-3" id="stateLabel">State *</label>
                                            <input type="text" id="stateSelect" class="inputBorder addressDiv" name="stateInput">
                                        </div>
                                    </div>
                                    <div class="pincodeMainDiv d-flex justify-content-between">
                                        <div class="countryDiv addressDiv">
                                            <label for="country" class="nameLabel mt-3" id="countryLabel">Country *</label>
                                            <input type="text" id="countrySelect" class="addressDiv inputBorder" name="countryInput">
                                        </div>
                                        <div class="pincodeDiv addressDiv">
                                            <label for="pincode" class="nameLabel mt-3" id="pincodeLabel">Pincode *</label>
                                            <input type="text" id="pincode" class="inputBorder addressDiv" placeholder="Your Pincode" name="pincode">
                                        </div>
                                    </div>
                                    <div class="emailMainDiv d-flex justify-content-between">
                                        <div class="emailDiv addressDiv">
                                            <label for="email" class="nameLabel mt-3" id="emailLabel">Email*</label>
                                            <input type="text" name="email" id="emailInput" class="inputBorder addressDiv" placeholder="Your Email Id">
                                        </div>
                                        <div class="mobileDiv addressDiv">
                                            <label for="mobile" class="nameLabel mt-3" id="mobileLabel">Mobile *</label>
                                            <input type="text" id="mobile" name="mobile" class="inputBorder addressDiv" placeholder="Your Number">
                                        </div>
                                    </div>
                                </div>
                                <span class="errorMessage" id="createErrorMessageTwo"></span>
                                <div class="crateDetailButtonDiv d-flex justify-content-center py-3">
                                    <button type="submit" class="createDetailButton" id="createDetailButton" name="createDetailButton" onclick="return createContactSumbit()">Create</button>
                                    <button type="submit" class="editDetailButton" id="editDetailButton" name="editDetailButton" onclick="return editContactSumbit()">Update</button>
                                </div>
                            </div>
                            <div class="showContactImage d-flex flex-column">
                                <div class="createCloseDiv d-flex justify-content-end">
                                    <button type="button" class="createClose border-0" onclick="createClose()"><img width="35" height="35" src="https://img.icons8.com/sf-regular/48/387cb4/close-window.png" alt="close-window"/></button>
                                </div>
                                <div class="createProfileImage px-4 py-3">
                                    <img src="assets/images/defaultProfile.jpg" alt="" width="110px" height="110px" class="mt-5 mx-2" id="editImage">
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
                                        <div class="contactLabel">Name</div>
                                        <div class="contactSymbol">:</div>
                                        <div class="contactName ms-4" id="contactName"></div>
                                    </div>
                                    <div class="contactNameDiv d-flex">
                                        <div class="contactLabel text-capitalize">Gender</div>
                                        <div class="contactSymbol">:</div>
                                        <div class="contactName ms-4" id="contactGender"></div>
                                    </div>
                                    <div class="contactNameDiv d-flex">
                                        <div class="contactLabel text-capitalize">Date of Birth</div>
                                        <div class="contactSymbol">:</div>
                                        <div class="contactName ms-4" id="contactDob"></div>
                                    </div>
                                    <div class="contactNameDiv d-flex">
                                        <div class="contactLabel text-capitalize">Address</div>
                                        <div class="contactSymbol">:</div>
                                        <div class="contactName ms-4" id="contactAddress"></div>
                                    </div>
                                    <div class="contactNameDiv d-flex">
                                        <div class="contactLabel text-capitalize">Pincode</div>
                                        <div class="contactSymbol">:</div>
                                        <div class="contactName ms-4" id="contactPincode"></div>
                                    </div>
                                    <div class="contactNameDiv d-flex">
                                        <div class="contactLabel text-capitalize">Email ID</div>
                                        <div class="contactSymbol">:</div>
                                        <div class="contactName ms-4" id="contactEmail"></div>
                                    </div>
                                    <div class="contactNameDiv d-flex">
                                        <div class="contactLabel text-capitalize">Mobile</div>
                                        <div class="contactSymbol">:</div>
                                        <div class="contactName ms-4" id="contactMobile"></div>
                                    </div>
                                    
                                </div>
                                <div class="crateDetailButtonDiv d-flex justify-content-center py-3">
                                    <button type="button" class="createDetailButton" id="crateDetailButton" onclick="viewContactClose()">CLOSE</button>
                                </div>
                            </div>
                            <div class="showContactImage d-flex px-4 py-5">
                                <img src="" alt="" width="110px" height="110px" class="mt-5"  id="contactImage">
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
            <cfif local.pdf.len()>
                <cfdocument format = "pdf" filename = "assets/pdfs/addressBookcontacts.pdf" overwrite="true" bookmark="no" orientation = "landscape">
                    <table>
                        <tr>
                            <th>FirstName</th>
                            <th>LastName</th>
                            <th>Gender</th>
                            <th>Email</th>
                            <th>Mobile</th>
                            <th>Address</th>
                            <th>Pincode</th>
                            <th>Image</th>
                        </tr>
                        <cfloop query="local.pdf">
                            <tr>
                                <td>#FirstName#</td>
                                <td>#LastName#</td>
                                <td>#Gender#</td>
                                <td>#Email#</td>
                                <td>#Mobile#</td>
                                <td>#Address#, #Street#, #District#, #State#, #Country#</td>
                                <td>#Pincode#</td>
                                <td><img src="assets/uploadImages/#Profile#" width="60" height="60"></td>
                            </tr>
                        </cfloop>  
                    </table>
                </cfdocument>
            </cfif>
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
            <script src="js/script.js"></script>
        </cfoutput>
    </body>
</html>