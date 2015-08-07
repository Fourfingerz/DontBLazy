var table = document.getElementById('active_tasks');
var tbody = table.getElementsByTagName('tbody')[0];
var rows  = tbody.getElementsByTagName('tr');


// For each row (active goal), do this:
for (var i=0, len=rows.length; i<len; i++){

 	// WHAT AM I DOING WITH EACH ROW

 	for each (var row in rows) {
 		columns = row.getElementsByTagName('td');
		time = columns[0]

	    if (parseInt(time.innerHTML,10) < 30){
	        rows[i].style.backgroundColor = 'red';
	    }
	    else if (parseInt(time.innerHTML,10) > 120){
	        rows[i].style.backgroundColor = 'green';
	    }
	}
}
