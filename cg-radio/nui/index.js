var radioToggled = false;
var changingPrimary = true;
var speaker = false;
var primary = 0;
var secondary = 0;

$(() => {
    window.addEventListener("message", event => {
        var item = event.data;

        if(item.show) {
            $("body").show();
        } else {
            $("body").hide();
        }
    });

    document.onkeyup = data => {
        if(data.which == 27) $.post("https://cg-radio/close", JSON.stringify({}))
    };

    $("#freq").submit(e => {
        e.preventDefault();
        if(changingPrimary) {
            $.post("https://cg-radio/freqPrimary", JSON.stringify({ channel: $("#radio-channel").val() }));
            primary = $("#radio-channel").val();
        } else {
            $.post("https://cg-radio/freqSecondary", JSON.stringify({ channel: $("#radio-channel").val() }));
            secondary = $("#radio-channel").val();
        }
    });

    $("#radio-channel").val(primary);
});

function Toggle() {
    if(radioToggled) {
        radioToggled = false;
        $("#radio-screen").hide();
        $("#radio-img").attr("src", "radio-off.png");
        $.post("https://cg-radio/leave", JSON.stringify({}));
        primary = 0;
        secondary = 0;
    } else {
        radioToggled = true;
        $("#radio-img").attr("src", "radio-on.png");
        $.post("https://cg-radio/turnOn", JSON.stringify({}));
        setTimeout(() => {
            if(radioToggled) $("#radio-screen").show();
        }, 1000);
    }
}

function VolUp() {
    $.post("https://cg-radio/volUp", JSON.stringify({}));
}

function VolDown() {
    $.post("https://cg-radio/volDown", JSON.stringify({}));
}

function setTwoNumberDecimal() {
    $("#radio-channel").val(parseFloat($("#radio-channel").val()).toFixed(2));
}

function SwitchType() {
    changingPrimary = !changingPrimary
    if(changingPrimary) {
        $("#channel-type").text("Primary");
        $("#radio-channel").val(primary);
    } else {
        $("#channel-type").text("Secondary");
        $("#radio-channel").val(secondary);
    }
}

function Speaker() {
    $.post("https://cg-radio/speaker", JSON.stringify({}));
    speaker = !speaker;
    if(speaker) {
        $("#speaker-text").text("Yes");
    } else {
        $("#speaker-text").text("No");
    }
}