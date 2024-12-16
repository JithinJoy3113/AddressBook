var selectedValues = [];
document.addEventListener('DOMContentLoaded', function () {
    const multiselectInput = document.getElementById('multiselectInput');
    const optionsContainer = document.getElementById('optionsContainer');
    const selectedTags = document.getElementById('selectedTags');

    // Toggle options dropdown
    multiselectInput.addEventListener('click', function () {
        optionsContainer.style.display = optionsContainer.style.display === 'block' ? 'none' : 'block';
    });

    // Select an option
    optionsContainer.addEventListener('click', function (event) {
        console.log(selectedValues)
        if (event.target.classList.contains('option')) {
            const value = event.target.getAttribute('data-value');
            const text = event.target.textContent;

            if (!selectedValues.includes(value)) {
                selectedValues.push(value);
                const tag = document.createElement('span');
                tag.classList.add('selectedTag');
                tag.textContent = text;
                tag.setAttribute('data-value', value);
                selectedTags.appendChild(tag);
                multiselectInput.classList.remove('placeholder');
                multiselectInput.textContent = '';
            }
        }
    });

    selectedTags.addEventListener('click', function (event) {
        if (event.target.classList.contains('selectedTag')) {
            const value = event.target.getAttribute('data-value');
            selectedValues=selectedValues.filter(item => item !== value);
            event.target.remove();
        }
    });

    document.addEventListener('click', function (event) {       //close option
        if (!event.target.closest('.multiselectContainer')) {
            optionsContainer.style.display = 'none';
        }
    });
});


$(document).on("click", function () {
    $(".removeSpan").hide();
});

function viewContact(ID){
    let id = ID.value;
    if(id){
        $.ajax({
            url:'./Components/addressbook.cfc?method=viewContact',
            type: "post",
            data:{
                id: id
            },
            success: function (response) {
                let data = JSON.parse(response);
                let dateNew = new Date(data.DOB);
                formatDate = dateNew.getDate()+"/"+dateNew.getMonth()+"/"+dateNew.getFullYear();
                $("#showContactDiv").css({"display":"flex"});
                $('#bodyContents').addClass('disabled');
                $("#contactName").text(data.FIRSTNAME+ data.LASTNAME);
                $("#contactGender").text(data.GENDER);
                $("#contactDob").text(formatDate);
                $("#contactRole").text(data.ROLES);
                $("#contactAddress").text(`${data.ADDRESS}, ${data.STREET}, ${data.DISTRICT}, ${data.STATE}, ${data.COUNTRY}`);
                $("#contactPincode").text(data.PINCODE);
                $("#contactEmail").text(data.EMAIL);
                $("#contactMobile").text(data.MOBILE);
                let imagePath = `assets/uploadImages/${data.PROFILE}`
                $("#contactImage").attr("src", imagePath);
            }
         });
    }
    else{
        valid = false;
    }
}

function viewContactClose(){
    $("#showContactDiv").css({"display":"none"});
    $('#bodyContents').removeClass('disabled');
    $("#showExcelDiv").css({"display":"none"});
}

function createClose(){
    selectedValues=[];
    $('.selectedTags').text('')
    $('#bodyContents').removeClass('disabled');
    $("#createEditDiv").css({"display":"none"});
    $('#showContactInfoDiv').find('label').css({'color':"#387cb4"});
    $('#createErrorMessage').text('');
    $('#createErrorMessageTwo').text('');
}


function createContact(){
    $('#showContactInfoDiv').find('input,select').val('');
    $("#editImage").attr("src", "assets/uploadImages/defaultProfile.jpg");
    $("#createEditDiv").css({"display":"flex"});  
    $('#bodyContents').addClass('disabled');
    $("#showContactHead").text("CREATE CONTACT");
    $("#editDetailButton").css({"display":"none"});
    $("#createDetailButton").css({"display":"flex"});
}

function validate(){
    let valid = true; 

    let title = $('#titleSelect').val();
    let firstName = $('#firstNameInput').val();
    let lastName = $('#lastNameInput').val();
    let gender = $('#genderSelect').val();
    let dob = $('#dateInputField').val();
    let address = $('#addressInput').val();
    let street = $('#streetInput').val();
    let district = $('#districtSelect').val();
    let state = $('#stateSelect').val();
    let country = $('#countrySelect').val();
    let pincode = $('#pincode').val();
    let email = $('#emailInput').val();
    let mobile = $('#mobile').val();

    if(title == ""){
        $('#titleLabel').css({"color":"red"});
        valid = false;
    }
    else{
        $('#titleLabel').css({"color":"#387cb4"});
    }

    if(firstName == ""){
        $('#firstNameLabel').css({"color":"red"});
        valid = false;
    }
    else{
        $('#firstNameLabel').css({"color":"#387cb4"});
    }

    if(lastName == ""){
        $('#lastNameLabel').css({"color":"red"});
        valid = false;
    }
    else{
        $('#lastNameLabel').css({"color":"#387cb4"});
    }

    if(!selectedValues.length){
        $('#roleLabel').css({"color":"red"});
        valid = false;
    }
    else{
        $('#roleLabel').css({"color":"#387cb4"});
        $('#optionInsert').val(selectedValues);
    }

    if(gender == ""){
        $('#genderLabel').css({"color":"red"});
        valid = false;
    }
    else{
        $('#genderLabel').css({"color":"#387cb4"});
    }

    if(dob == ""){
        $('#dobLabel').css({"color":"red"});
        valid = false;
    }
    else{
        $('dobLabel').css({"color":"#387cb4"});
    }

    if(address == ""){
        $('#addressLabel').css({"color":"red"});
        valid = false;
    }
    else{
        $('#addressLabel').css({"color":"#387cb4"});
    }

    if(street == ""){
        $('#streetLabel').css({"color":"red"});
        valid = false;
    }
    else{
        $('#streetLabel').css({"color":"#387cb4"});
    }

    if(country == ""){
        $('#countryLabel').css({"color":"red"});
        valid = false;
    }
    else{
        $('#countryLabel').css({"color":"#387cb4"});
    }

    if(state == ""){
        $('#stateLabel').css({"color":"red"});
        valid = false;
    }
    else{
        $('#stateLabel').css({"color":"#387cb4"});
    }

    if(district == ""){
        $('#districtLabel').css({"color":"red"});
        valid = false;
    }
    else{
        $('#districtLabel').css({"color":"#387cb4"});
    }

    if(email == "" || !/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){
        $('#emailLabel').css({"color":"red"});
        valid = false;
    }
    else{
        $('#emailLabel').css({"color":"#387cb4"});
    }
    
    if(pincode == "" || !/^\d{6}$/.test(pincode)){
        $('#pincodeLabel').css({"color":"red"});
        valid = false;
    }
    else{
        $('#pincodeLabel').css({"color":"#387cb4"});
    }
    
    if(mobile == "" || !/^\d{10}$/.test(mobile)){
        $('#mobileLabel').css({"color":"red"});
        valid = false;
    }
    else{
        $('#mobileLabel').css({"color":"#387cb4"});
    }
    if (valid){
        return valid
    }
}

function createContactSumbit(){
    let valid = validate();
    if(valid){
        $("#createEditDiv").css({"display":"none"});  
        $("#createDetailButton").css({"display":"none"});
        $('#bodyContents').removeClass('disabled');
    }
    else{
        $('#createErrorMessage').text("Please enter valid datas for required(*) fields");
        $('#createErrorMessageTwo').text("Please enter valid datas for required(*) fields");
        valid = false;
    }
    return valid;
}

let editId;
function editContact(ID){
    $('#uploadProfile').val('');
    editId = ID.value;
        $.ajax({
            url:'./Components/addressbook.cfc?method=viewContact',
            type: "post",
            data:{
                id:editId
            },
            success: function (response) {
                let data = JSON.parse(response);
                let roles=data.ROLES.split(",");
                $("#createEditDiv").css({"display":"flex"}); 
                $("#editDetailButton").css({"display":"flex"});
                $("#createDetailButton").css({"display":"none"});
                $('#bodyContents').addClass('disabled');
                $("#showContactHead").text("EDIT CONTACT");
                let dateNew = new Date(data.DOB);
                let month = dateNew.getMonth()+1
                let year = dateNew.getFullYear()
                let day = dateNew.getDate()
                if(month < 10){
                    month = '0'+month
                }
                if(day < 10){
                    day  = '0'+day
                }
                formatDate = year+"-"+month+"-"+day;

                for (var i=0; i < roles.length;i++){
                    let string=roles[i];
                    let roleID={"Role1":"1","Role2":"2","Role3":"3","Role4":"4"}
                    const tag = document.createElement('span');
                    tag.classList.add('selectedTag');
                    tag.textContent = string;
                    tag.setAttribute('data-value', roleID[string]);
                    selectedTags.appendChild(tag);
                    selectedValues.push(roleID[string]);
                }

                $("#editingID").val(data.ID);
                $("#titleSelect").val(data.TITLE);
                $("#firstNameInput").val(data.FIRSTNAME);
                $("#lastNameInput").val(data.LASTNAME);
                $("#genderSelect").val(data.GENDER);
                $("#dateInputField").val(formatDate);
                $("#addressInput").val(data.ADDRESS);
                $("#streetInput").val(data.STREET);
                $("#districtSelect").val(data.DISTRICT);
                $("#stateSelect").val(data.STATE);
                $("#countrySelect").val(data.COUNTRY);
                $("#pincode").val(data.PINCODE);
                $("#emailInput").val(data.EMAIL);
                $("#mobile").val(data.MOBILE);
                let imagePath = `assets/uploadImages/${data.PROFILE}`
                $("#editImage").attr("src", imagePath);
            }
            });
    }
 
function editContactSumbit(){
    let valid = validate();
    if(valid){
        $("#editDetailButton").css({"display":"none"});
        $("#createEditDiv").css({"display":"none"});
        $('#bodyContents').removeClass('disabled');
        return valid;
            }
    else{
        $('#createErrorMessage').text("Please enter valid datas for required(*) fields");
        $('#createErrorMessageTwo').text("Please enter valid datas for required(*) fields");
        valid = false;
    }
    return valid;
}

var deleteId;
function deleteButton(ID){
    deleteId = ID.value;
    $("#deleteConfirm").css({"display":"flex"});
    $("#bodyContents").addClass("disabled");
}

function deleteAlert(confirm){ 

    let valid = true;
    if(confirm == "yes"){
        $.ajax({
            url:'./Components/addressbook.cfc?method=deleteRow',
            type: "post",
            data:{
                id:deleteId
            },
            success: function (response) {
                if(response){
                    $("#deleteConfirm").css({"display":"none"});
                    $('#bodyContents').removeClass('disabled');
                    document.getElementById(deleteId).remove();
                }
            }
         });
    }
    else{
        valid = false;
        $("#deleteConfirm").css({"display":"none"});
        $('#bodyContents').removeClass('disabled');
    }
}

function logoutValidate(){
    $("#logoutConfirm").css({"display":"flex"});
    $("#bodyContents").addClass("disabled");
}

function logoutAlert(value){

    let valid = true;
    if(value == 'yes'){
        $.ajax({
            url:'./Components/addressbook.cfc?method=logout',
            type: "post",
            success: function (response) {
                if(response){
                    $("#logoutConfirm").css({"display":"none"});
                    $("#bodyContents").removeClass("disabled");
                }
                else{
                    valid = false
                }
            }
         });
    }
    else{
        valid = false;
        $("#logoutConfirm").css({"display":"none"});
        $("#bodyContents").removeClass("disabled");
    }
    return valid;
}

function signUpValidate(){

    let fullName = $('#fullNameInput').val();
    let email = $('#emailInput').val();
    let userName = $('#userNameInput').val();
    let password = $('#passwordInput').val();
    let confirm = $('#confirmInput').val();

    let valid = true;
  
    if(fullName == ''){
        $('#nameError').text("Name must not be empty!");
        valid = false;
    } 
    else{
        $('#nameError').text("");
    }

    if (email == ''){  
        $('#emailError').text("Email ID must not be empty!");
        valid = false;
    }
    else if( !/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){
        $('#emailError').text("Invalid Email ID!");
        valid = false;
    }
    else{
        $('#emailError').text('');
    } 
    
    if(userName == ""){
        $('#userNameError').text('UserName must not be empty!');
        valid = false;
    }
    else{
        $('#userNameError').text('');
    }
    
    if(password == ""){
        $('#passwordError').text('Password must not be empty!');
        valid = false;
    }
    else if (!/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s).{8,25}$/.test(password)){
        $('#passwordError').text('Please enter a strong password');
        valid = false;
    }else{
        $('#passwordError').text('');
    }

    if(confirm == ""){
        $('#confirmError').text('Confirm Password must not be empty!');
        valid = false;
    }
    else if (password !=  confirm){
        $('#confirmError').text('Password Missmatch');
        valid = false;
    }else{
        $('#confirmError').text('');
    }
    return valid;
}

function loginValidation(){
    let email = $('#userNameInput').val();
    let password = $('#passwordInput').val();

    let valid = true;

    if (email == ''){  
        $('#emailError').text("Please enter your user name");
        valid = false;
    }
    else{
        $('#emailError').text("");
    }
    if (password == ''){  
        $('#passwordError').text("Please enter your password");
        valid = false;
    }
    else{
        $('#passwordError').text("");
    } 
    return valid;
}

function printContacts(){

    var printContents = document.getElementById("userContactsDiv").innerHTML;
    var originalContents = document.body.innerHTML;
    document.body.innerHTML = printContents;
    $(".editButton").css({"display":"none"})
    window.print();
    document.body.innerHTML = originalContents;
}

function getExcelOrPdf(){
    $.ajax({
        url:'./Components/addressbook.cfc?method=getExcelOrPdf',
        type: "post"
    })
}

function pdfDownload(key){
    $.ajax({
        url:'./Components/addressbook.cfc?method=getExcelOrPdf',
        type: "post",
        data:{
            value:key
        },
        success:function(response){
            let path=JSON.parse(response)
            let tag=document.createElement('a');
            tag.href=`assets/${key}/${path}`;
            tag.download=path;
            tag.click();
            tag.remove();
        }
    })
}

function createContactExcel(){
    $("#showExcelDiv").css({"display":"flex"});
    $('#bodyContents').addClass('disabled');
}

function plainExcelTemplate(){
    $.ajax({
        url:'./Components/addressbook.cfc?method=plainExcelSheet',
        type: "post",
        success:function(response){
            let tag=document.createElement('a');
            let path="plainTemplate.xlsx"
            tag.href=`assets/spreadSheets/plainTemplate.xlsx`;
            tag.download=path;
            tag.click();
            tag.remove();
        }
    })
    }

