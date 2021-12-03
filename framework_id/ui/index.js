$(document).ready(() => {

    window.addEventListener("message", (event) => {
        var data = event.data;

        if(data.enabled) {
            $("#clientPhoto").attr("src", "");
            $("#clientSSN").html(data.ssn);
            $("#clientDOB").html(data.dob);
            $("#clientLname").html(data.lastName);
            $("#clientFname").html(data.firstName);
            $("#clientPhoto").attr("src", data.txd);

            $(".idcard").show();
        } else if(!data.enabled) {
            $(".idcard").hide();
        }
    });

});