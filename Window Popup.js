//@input SceneObject[] windows
//@input SceneObject[] windows2
// @input SceneObject windowParent
// @input SceneObject windowParent2

var count = 0;
var count2 = 0;

function toggleOG(){   
    if(count > 0){
        var i = count - 1;
        script.windows[i].enabled = false;
    } 
    
    for (let i = 0; i < script.windows.length; i++){
        script.windows[count].enabled = true;       
    }

    count++;
    print(count);
}

function toggleOG2(){   
    if(count2 > 0){
        var i = count2 - 1;
        script.windows2[i].enabled = false;
    } 
    
    for (let i = 0; i < script.windows2.length; i++){
        script.windows2[count2].enabled = true;       
    }

    count2++;
    print(count2);
}

function toggleWindow() {
    for (i = 0; i < script.windows.length; i++){
        script.windows[currentWindowIndex].enabled = true; 
    }
    script.windowParent.enabled = !script.windowParent.enabled;
}

function toggleWindow2() {
    for (i = 0; i < script.windows2.length; i++){
        script.windows2[currentWindowIndex2].enabled = true; 
    }
    script.windowParent2.enabled = !script.windowParent2.enabled;
}

var currentWindowIndex = 0;
var currentWindowIndex2 = 0;

function nextWindow() {
    // hide all windows
    for (i = 0; i < script.windows.length; i++){
        script.windows[currentWindowIndex].enabled = false; 
    }
    
    
    // increment window index
    currentWindowIndex++;
    print(currentWindowIndex);
    
    if (currentWindowIndex < script.windows.length) {
        script.windows[currentWindowIndex].enabled = true;
    }
    
    // if index > array legnth, close everything
    if (currentWindowIndex == script.windows.length) {
        currentWindowIndex = 0;  
        for (i = 0; i < script.windows.length; i++){
            script.windows[i].enabled = false;       
        }
        script.windowParent.enabled = false;
        print("done");
    }
    
    
    // if index < array length, enable window based on index
    
}

function nextWindow2() {
    // hide all windows
    for (i = 0; i < script.windows2.length; i++){
        script.windows2[currentWindowIndex2].enabled = false; 
    }
    
    
    // increment window index
    currentWindowIndex2++;
    print(currentWindowIndex2);
    
    if (currentWindowIndex2 < script.windows2.length) {
        script.windows2[currentWindowIndex2].enabled = true;
    }
    
    // if index > array legnth, close everything
    if (currentWindowIndex2 == script.windows2.length) {
        currentWindowIndex2 = 0;  
        for (i = 0; i < script.windows2.length; i++){
            script.windows2[i].enabled = false;       
        }
        script.windowParent2.enabled = false;
        print("done");
    }
    
    
    // if index < array length, enable window based on index
    
}
function onStart() {
    print("starting up")
    script.windowParent.enabled = false;
    script.windowParent2.enabled = false;
    script.windows[currentWindowIndex].enabled = true;
    script.windows2[currentWindowIndex2].enabled = true;
    print("started up")
}


// script.toggle = toggleOG;
script.toggleWindow = toggleWindow;
script.toggleWindow2 = toggleWindow2;
script.nextWindow = nextWindow;
script.nextWindow2 = nextWindow2;


onStart();