function formatDate(timestamp) {
    //We receive Unix Epoch timestamp, which needs to be converted into the one we need. 
    var date = new Date(timestamp * 1000);
    var year = date.getFullYear();
    var month = date.getMonth() + 1;
    var day = date.getDate();
    var hours = date.getUTCHours().toString();
    var minutes = date.getUTCMinutes().toString();
    var seconds = date.getUTCSeconds().toString();
    if (hours.length == 1) {
        hours = '0' + hours
    }
    if (minutes.length == 1) {
        var minutes = '0' + minutes
    }
    if (seconds.length == 1) {
        var seconds = '0' + seconds
    }
    // Return the timestamp in IBM i format CCYY-MM-DD-HH.MM.SS
    return (year + "-" + month + "-" + day + "-" + hours + "." + minutes + "." + seconds);
}

module.exports = formatDate