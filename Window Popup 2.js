//@input SceneObjec window

function toggle(){
    for (var i =0; i < script.windows.length; i++){
        script.windows.enabled[i] = !script.windows.enabled[i];
    }
    
}

script.toggle = toggle;