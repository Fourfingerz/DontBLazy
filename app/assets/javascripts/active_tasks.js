var table = document.getElementById('active_tasks');
var tbody = table.getElementsByTagName('tbody')[0];
var rows = tbody.getElementsByTagName('tr');


// For each row (active goal), do this:
for (var i=0, len=rows.length; i<len; i++) {
        var row = rows[i];
        var columns = row.getElementsByTagName('td');
        var time = columns[0]

        if (parseInt(time.innerHTML, 10) == 30) {
            time.style.backgroundColor = 'red';
        } else if (parseInt(time.innerHTML, 10) == 120) {
            time.style.backgroundColor = 'green';
        }
           
};
            