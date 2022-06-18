
function maximize_restore(){
    if(window_status == 0){
        window_status = 1
        main_window.showMaximized()
    }else{
        window_status = 0
        main_window.showNormal()
    }
}
