window.onload = function() {
    var table = document.getElementById("active_tasks_table");
    var tbody = table.getElementsByTagName('tbody')[0];
    var rows = tbody.getElementsByTagName('tr');


    // For each row (active goal), do this:
    for (var i=0, len=rows.length; i<len; i++) {
        var row = rows[i];
        var columns = row.getElementsByTagName('td');

        var time = columns[0]
        var seconds_due = time.getAttribute('data-due');
        var seconds = parseInt(seconds_due, 10);

        if (seconds < 1800) {                            // Less than 30 minutes
            time.style.backgroundColor = 'red';
        } else if (seconds > 1800 && seconds < 7200) {   // More than 30 and less than 2 hours
            time.style.backgroundColor = 'orange';   
        } else if (seconds > 7200 && seconds < 21600) {  // More than 2 hours and less than 6 hours 
            time.style.backgroundColor = 'yellow';
        } else {
            time.style.backgroundColor = 'green';
        }         
    }
};
            