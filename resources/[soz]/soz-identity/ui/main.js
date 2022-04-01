function Delay(delay) {
    return new Promise((resolve) => {
        setTimeout(() => {
            resolve();
        }, delay);
    });
}

async function HideUI(...elements) {
    elements.forEach(el => {
        el.style.opacity = 0;
    });
    await Delay();
    elements.forEach(el => {
        el.style.display =  "none";
    });
    return;
}

let visible = false;
let source = null;
async function setVisible(value, src) {
    const identityElement = document.querySelector("#identity");
    const licensesElement = document.querySelector("#licenses");

    if (visible) {
        visible = false;
        source = null;
        await HideUI(identityElement, licensesElement);
    }

    // Display identity or licences
    const fadeIn = async (el) => {
        visible = true;
        source = src;
        el.style.display = "flex";
        el.style.opacity = 0;
        await Delay(10);
        el.style.opacity = 1;
    }

    if (value === "identity") await fadeIn(identityElement);
    else if (value === "licenses") await fadeIn(licensesElement);
}

// NUI Events
window.addEventListener("message", (event) => {
    const scope = event.data.scope;
    const type = event.data.type;
    const src = event.data.source;

    if (scope === "identity" && type === "display") {
        displayIdentityData(event.data);
        setVisible(scope, src);
    }

    if (scope === "mugshot") {
        displayMugshot(event.data.mugshot);
    }
    
    if (scope === "licenses" && type === "display") {
        displayLicensesData(event.data.licences);
        displayPlayerName(
            event.data.firstName,
            event.data.lastName
        );
        setVisible(scope, src);
    }

    if (event.data.type === "hide") {
        if (!src || src === source) {
            setVisible(false, null);
        }
    }
});
