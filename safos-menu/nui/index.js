let buttonsData = [];
let buttons = [];
let button = [];

const openMenu = data => {
    drawButtons(data)
}

const closeMenu = () => {
    for(let i = 0; i < buttonsData.length; i++) {
        let id = buttonsData[i].id;
        $(".button").remove();
    }
    buttonsData = [];
    buttons = [];
    button = [];
}

const drawButtons = data => {
    buttonsData = data;
    for(let i = 0; i < buttonsData.length; i++) {
        let header = buttonsData[i].header;
        let message = buttonsData[i].txt;
        let id = buttonsData[i].id;
        let element;

        element = $(`
        <div class="button" id=` + id + `>
            <div class="header" id=` + id + `>` + header + `</div>
            <div class="txt" id=` + id + `>` + message + `</div>
        </div>`);
        $("#buttons").append(element);
        buttons[id] = element;
        if(buttonsData[i].params) button[id] = buttonsData[i].params;
    }
}

const postData = id => {
    $.post("https://safos-menu/dataPost", JSON.stringify(button[id]));
    return closeMenu();
}

const cancelMenu = () => {
    $.post("https://safos-menu/cancel");
    return closeMenu();
}

$(document).click(function(event) {
    let $target = $(event.target);
    if($target.closest(".button").length && $(".button").is(":visible")) {
        let id = event.target.id;
        if(!button[id]) return;
        postData(id);
    }
})

window.addEventListener("message", event => {
    let item = event.data;
    let info = item.data;
    let action = item.action;

    switch(action) {
        case "openMenu":
            return openMenu(info)
        case "closeMenu":
            return closeMenu()
        default:
            return;
    }
})

document.onkeyup = function(event) {
    event = event || window.event;
    var charCode = event.keyCode || event.which;
    if(charCode == 27) cancelMenu();
}