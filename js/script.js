function viewContact(){
    $("#showContactDiv").css({"display":"flex"});  
    document.getElementById("bodyContents").classList.add("disabled");
}
function viewContactClose(){
    $("#showContactDiv").css({"display":"none"});  
    document.getElementById("bodyContents").classList.remove("disabled");
}
function createContact(){
    $("#createEditDiv").css({"display":"flex"});  
    document.getElementById("bodyContents").classList.add("disabled");
}
function createContactSumbit(){
    $("#createEditDiv").css({"display":"none"});  
    document.getElementById("bodyContents").classList.remove("disabled");
}