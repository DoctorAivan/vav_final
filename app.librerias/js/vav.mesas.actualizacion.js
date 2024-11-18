//	Tiempo de permanencia del TAG
    const mesas_nueva_expiracion = 60

//  Actualizar el tiempo y estilo de la ultima modificación
    function mesas_ultima_actualizacion()
	{
	//	Obtener tiempo actual
		const now = Date.now();
        const timestamp = Math.floor( now / 1000 );

	//	Selecciona todos los elementos con la clase "timeago"
		document.querySelectorAll('.timeago').forEach(element =>
		{
		//	Obtener el timestamp en segundos desde el atributo "updated"
			const updatedTimestamp = parseInt(element.getAttribute('datetime'), 10) * 1000;

		//	Calcular el tiempo transcurrido en milisegundos
			const elapsed = now - updatedTimestamp;

		//	Definir los valores de tiempo en milisegundos para cada unidad
			const seconds = Math.floor(elapsed / 1000);
			const minutes = Math.floor(seconds / 60);
			const hours = Math.floor(minutes / 60);
			const days = Math.floor(hours / 24);
			const months = Math.floor(days / 30);
			const years = Math.floor(days / 365);

		//	Determinar el texto de "hace X" según el tiempo transcurrido
			let newText;
			if (seconds < 60) {
				newText = `Hace ${seconds} segundo${seconds !== 1 ? 's' : ''}`;
			} else if (minutes < 60) {
				newText = `Hace ${minutes} minuto${minutes !== 1 ? 's' : ''}`;
			} else if (hours < 24) {
				newText = `Hace ${hours} hora${hours !== 1 ? 's' : ''}`;
			} else if (days < 30) {
				newText = `Hace ${days} día${days !== 1 ? 's' : ''}`;
			} else if (months < 12) {
				newText = `Hace ${months} mes${months !== 1 ? 'es' : ''}`;
			} else {
				newText = `Hace ${years} año${years !== 1 ? 's' : ''}`;
			}

        //  Obtener el Contenedor
			const mesa_contenedor = element.parentElement.parentElement.parentElement

		//  Solo actualizar los valores si el resultado es diferente
			if (element.innerHTML !== newText) {

            //  Actualizar tiempo
				element.innerHTML = newText;

            //	Limpiar clases de color y agregar solo la necesaria
                mesa_contenedor.classList.remove('verde', 'amarillo', 'rojo');

            //  Asignar color segun el tiempo transcurrido
                if (seconds < 60) {
                    mesa_contenedor.classList.add('verde');
                } else if (seconds <= 120) {
                    mesa_contenedor.classList.add('amarillo');
                } else {
                    mesa_contenedor.classList.add('rojo');
                }

			//  Obtener la fecha de la creación
				const created = Number( mesa_contenedor.getAttribute("created") );

			//  Validar que el timestamp sea mayor
				if( (timestamp - created) >= mesas_nueva_expiracion )
				{
					mesa_contenedor.classList.add('antigua')
				}
			}
		});
	}

//	Actualizar el numero total de mesas en pantalla
	function mesas_totales_actualizacion()
	{
	//	Obtener el contenedor
		const total_mesas_numero = document.getElementById('total-mesas-numero');
		const total_mesas_valor = document.getElementById('total-mesas-valor');

	//	Asignar los valores en el DOM
		total_mesas_numero.innerHTML = mesas_totales;
		total_mesas_valor.innerHTML = `MESA${mesas_totales !== 1 ? 'S' : ''}`;
	}
