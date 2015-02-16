
document.getElementById('h_24x4').style.display = 'none';


var list = document.getElementsByTagName('iframe');
var array = [].slice.call(list);
for (index = 0; index < array.length; ++index) {
    array[index].style.display = 'none';
    array[index].id = 'blocked-iframe';
}

