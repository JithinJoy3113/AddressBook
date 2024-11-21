function viewContact(ID){
    let id=ID.value;
    if(id){
        $.ajax({
            url:'./Components/component.cfc?method=viewContact',
            type: "post",
            data:{
                id:id
            },
            success: function (response) {   
                let data=JSON.parse(response);
                let dateNew=new Date(data.DOB);
                formatDate=dateNew.getDate()+"/"+dateNew.getMonth()+"/"+dateNew.getFullYear();
                $("#showContactDiv").css({"display":"flex"});  
                $('#bodyContents').addClass('disabled');
                $("#contactName").text(data.FIRSTNAME+ data.LASTNAME);
                $("#contactGender").text(data.GENDER);
                $("#contactDob").text(formatDate);
                $("#contactAddress").text(`${data.ADDRESS}, ${data.STREET}, ${data.DISTRICT}, ${data.STATE}, ${data.COUNTRY}`);
                $("#contactPincode").text(data.PINCODE);
                $("#contactEmail").text(data.EMAIL);
                $("#contactMobile").text(data.MOBILE);
                let imagePath=`assets/uploadImages/${data.PROFILE}`
                $("#contactImage").attr("src", imagePath);
            }
         });
    }
    else{
        valid=false;
    }
}

function viewContactClose(){
    $("#showContactDiv").css({"display":"none"});  
    $('#bodyContents').removeClass('disabled');
}

function createClose(){
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
    
    let valid=true; 

    let title=document.getElementById('titleSelect').value;
    let firstName=document.getElementById('firstNameInput').value;
    let lastName=document.getElementById('lastNameInput').value;
    let gender=document.getElementById('genderSelect').value;
    let dob=document.getElementById('dateInputField').value;
    let address=document.getElementById('addressInput').value;
    let street=document.getElementById('streetInput').value;
    let district=document.getElementById('districtSelect').value;
    let state=document.getElementById('stateSelect').value;
    let country=document.getElementById('countrySelect').value;
    let pincode=document.getElementById('pincode').value;
    let email=document.getElementById('emailInput').value;
    let mobile=document.getElementById('mobile').value;

    if(title == ""){
        document.getElementById('titleLabel').style.color="red";
        valid=false;
    }
    else{
        document.getElementById('titleLabel').style.color="#387cb4";
    }

    if(firstName==""){
        document.getElementById('firstNameLabel').style.color="red";
        valid=false;
    }
    else{
        document.getElementById('firstNameLabel').style.color="#387cb4";
    }

    if(lastName==""){
        document.getElementById('lastNameLabel').style.color="red";
        valid=false;
    }
    else{
        document.getElementById('lastNameLabel').style.color="#387cb4";
    }
    
    if(gender==""){
        document.getElementById('genderLabel').style.color="red";
        valid=false;
    }
    else{
        document.getElementById('genderLabel').style.color="#387cb4";
    }

    if(dob==""){
        document.getElementById('dobLabel').style.color="red";
        valid=false;
    }
    else{
        document.getElementById('dobLabel').style.color="#387cb4";
    }

    if(address==""){
        document.getElementById('addressLabel').style.color="red";
        valid=false;
    }
    else{
        document.getElementById('addressLabel').style.color="#387cb4";
    }

    if(street==""){
        document.getElementById('streetLabel').style.color="red";
        valid=false;
    }
    else{
        document.getElementById('streetLabel').style.color="#387cb4";
    }

    if(country==""){
        document.getElementById('countryLabel').style.color="red";
        valid=false;
    }
    else{
        document.getElementById('countryLabel').style.color="#387cb4";
    }

    if(state==""){
        document.getElementById('stateLabel').style.color="red";
        valid=false;
    }
    else{
        document.getElementById('stateLabel').style.color="#387cb4";
    }

    if(district==""){
        document.getElementById('districtLabel').style.color="red";
        valid=false;
    }
    else{
        document.getElementById('districtLabel').style.color="#387cb4";
    }

    if(email=="" || !/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){
        document.getElementById('emailLabel').style.color="red";
        valid=false;
    }
    else{
        document.getElementById('emailLabel').style.color="#387cb4";
    }
    
    if(pincode=="" || !/^\d{6}$/.test(pincode)){
        document.getElementById('pincodeLabel').style.color="red";
        valid=false;
    }
    else{
        document.getElementById('pincodeLabel').style.color="#387cb4";
    }
    
    if(mobile=="" || !/^\d{10}$/.test(mobile)){
        document.getElementById('mobileLabel').style.color="red";
        valid=false;
    }
    else{
        document.getElementById('mobileLabel').style.color="#387cb4";
    }
    if (valid){
        return valid
    }

}

function createContactSumbit(){
    let valid=validate();
    if(valid){
        $("#createEditDiv").css({"display":"none"});  
        $("#createDetailButton").css({"display":"none"});
        $('#bodyContents').removeClass('disabled');
    }
    else{
        $('#createErrorMessage').text("Please enter valid datas for required(*) fields");
        $('#createErrorMessageTwo').text("Please enter valid datas for required(*) fields");
        valid=false;
    }
    return valid;
}

let editId;
function editContact(ID){
    editId=ID.value;
 
        $.ajax({
            url:'./Components/component.cfc?method=viewContact',
            type: "post",
            data:{
                id:editId
            },
            success: function (response) {   
                console.log(response)
                let data=JSON.parse(response);
                $("#createEditDiv").css({"display":"flex"}); 
                $("#editDetailButton").css({"display":"flex"});
                $("#createDetailButton").css({"display":"none"});
                $('#bodyContents').addClass('disabled');
                $("#showContactHead").text("EDIT CONTACT");
                let dateNew=new Date(data.DOB);
                let month=dateNew.getMonth()+1
                let year=dateNew.getFullYear()
                let day=dateNew.getDate()
                if(month < 10){
                    month='0'+month
                }
                if(day < 10){
                    day ='0'+day
                }
                formatDate=year+"-"+month+"-"+day;
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
                let imagePath=`assets/uploadImages/${data.PROFILE}`
                $("#editImage").attr("src", imagePath);
            }
            });
    }
 
function editContactSumbit(){
    let valid=validate();
    if(valid){
        $("#editDetailButton").css({"display":"none"});
                    $("#createEditDiv").css({"display":"none"});
                    $('#bodyContents').removeClass('disabled');
        return valid;
            }
    else{
        $('#createErrorMessage').text("Please enter valid datas for required(*) fields");
        $('#createErrorMessageTwo').text("Please enter valid datas for required(*) fields");
        valid=false;
    }
    return valid;
}



var deleteId;
function deleteButton(ID){
    deleteId=ID.value;
    $("#deleteConfirm").css({"display":"flex"});
    $('#displayContent').addClass('disabled');
}

function deleteAlert(confirm){
    
    let valid=true;
    if(confirm=="yes"){
        $.ajax({
            url:'./Components/component.cfc?method=deleteRow',
            type: "post",
            data:{
                id:deleteId
            },
            success: function (response) {
                if(response){
                    $("#deleteConfirm").css({"display":"none"});
                    $('#displayContent').removeClass('disabled');
                }
            }
         });
    }
    else{
        valid=false;
        $("#deleteConfirm").css({"display":"none"});
        $('#displayContent').removeClass('disabled');
    }
    return valid;
}

function logoutValidate(){
    $("#logoutConfirm").css({"display":"flex"});
    $("#bodyContents").addClass("disabled");
}

function logoutAlert(value){
    
    let valid=true;
    if(value=='yes'){
        console.log('asfgdhfnjm')
        $.ajax({
            url:'./Components/component.cfc?method=logout',
            type: "post",
            success: function (response) {
                if(response){
                    $("#logoutConfirm").css({"display":"none"});
                    $("#bodyContents").removeClass("disabled");
                }
                else{
                    valid=false
                }
            }
         });
    }
    else{
        valid=false;
        document.getElementById("logoutConfirm").style.display="none";
        $("#bodyContents").removeClass("disabled");
    }
    return valid;
}

function signUpValidate(){
    console.log("gdgbsdtbx")
    let fullName=document.getElementById('fullNameInput').value;
    let email=document.getElementById('emailInput').value;
    let userName=document.getElementById('userNameInput').value;
    let password=document.getElementById('passwordInput').value;
    let confirm=document.getElementById('confirmInput').value;
    let valid=true;
  
    if(fullName == ''){
        document.getElementById('nameError').textContent="Name must not be empty!";
        valid=false;
    } 
    else{
        document.getElementById('nameError').textContent="";
    }

    if (email == ''){  
        document.getElementById('emailError').textContent="Email ID must not be empty!";
        valid=false;
    }
    else if( !/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email)){
        document.getElementById('emailError').textContent="Invalid Email ID!";
        valid=false;
    }
    else{
        document.getElementById('emailError').textContent='';
    } 
    
    if(userName==""){
        document.getElementById('userNameError').textContent='UserName must not be empty!';
        valid=false;
    }
    else{
        document.getElementById('userNameError').textContent='';
    }
    
    if(password==""){
        document.getElementById('passwordError').textContent='Password must not be empty!';
        valid=false;
    }
    else if (!/^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[^a-zA-Z0-9])(?!.*\s).{8,25}$/.test(password)){
        document.getElementById('passwordError').textContent='Please enter a strong password';
        valid=false;
    }else{
        document.getElementById('passwordError').textContent='';
    }

    if(confirm == ""){
        document.getElementById('confirmError').textContent='Confirm Password must not be empty!';
        valid=false;
    }
    else if (password != confirm){
        document.getElementById('confirmError').textContent='Password Missmatch';
        valid=false;
    }else{
        document.getElementById('confirmError').textContent='';
    }
    return valid;
}

function loginValidation(){
    let email=document.getElementById('userNameInput').value;
    let password=document.getElementById('passwordInput').value

    let valid=true;

    if (email == ''){  
        document.getElementById('emailError').textContent="Please enter your user name";
        valid=false;
    }
    else{
        document.getElementById('emailError').textContent="";
    }
    if (password == ''){  
        document.getElementById('passwordError').textContent="Please enter your password";
        valid=false;
    }
    else{
        document.getElementById('passwordError').textContent="";
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