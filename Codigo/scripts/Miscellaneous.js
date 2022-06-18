//Processing of the path of an image
// Returns a list with the first element as the name of the Image, and a second element as the path of the image
function process_path(path){
    const last_slash_index = path.lastIndexOf('/')
    return [ path.slice(last_slash_index+1), path.substring(0,last_slash_index) ]
}
