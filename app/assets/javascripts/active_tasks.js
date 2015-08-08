var table = document.getElementById('active_tasks');
var tbody = table.getElementsByTagName('tbody')[0];
var rows = tbody.getElementsByTagName('tr');


// For each row (active goal), do this:
for (var i=0, len=rows.length; i<len; i++) {
        var row = rows[i];
        var columns = row.getElementsByTagName('td');

        // var seconds_till_due = columns.getElementById("due_time");

        var time = columns[0]

        if (parseInt(time.innerHTML, 10) < 1800) {
            time.style.backgroundColor = 'red';
        } else if (parseInt(time.innerHTML, 10) > 1800 && < 7200) {
            time.style.backgroundColor = 'orange';
        } else if (parseInt(time.innerHTML, 10) > 7200 && < 21600) {
            time.style.backgroundColor = 'yellow';
        } else {
            time.style.backgroundColor = 'green';
        }
           
};
            