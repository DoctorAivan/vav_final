//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
//	FUNCIONALIDAD PUBNUB
//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Total de mesas
	let mesas_totales = 0

//	Intervalo de validación de mesa nueva
	let mesas_timer = null

//	Intervalo de tiempo entre comprobación
	const mesas_nueva_comparacion = 5000

//	Tiempo de delay para actualizar
	const actualizar_mesas_delay = 1000;

//	Iniciar al Cargar
	$(function()
	{
	//	Almacenar el total de mesas
		mesas = document.querySelectorAll('#mesas > article')

	//	Actualizar el total de mesas
		mesas_totales = mesas.length

	//	Iniciar el intervalo para validar las mesas nuevas
		mesa_nueva_iniciar();

	//	Actualizar el numero total de mesas en pantalla
		mesas_totales_actualizacion();
	});

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Enlistar acciones a ejecutar
	function mesas_actualizar_acciones()
	{
	//  Actualizar el tiempo y estilo de la ultima modificación
		mesas_ultima_actualizacion();

	//	Delay de ejecución
		setTimeout(function()
		{
		//	Ordenar mesas en el DOM
			actualizarOrdenTimer();
/*
		// Obtener el contenedor con ID "mesas"
			const contenedor = document.getElementById("mesas");

		// Convertir los hijos en un array y ordenar en base al atributo "date"
			const elementosOrdenados = Array.from(contenedor.children)
			.sort((a, b) => {
			// Obtener el valor del atributo "date" y convertirlo a número
				const dateA = parseInt(b.getAttribute("date"), 10);
				const dateB = parseInt(a.getAttribute("date"), 10);
				return dateA - dateB;
			});

			// Vaciar el contenedor
			contenedor.innerHTML = "";

			// Agregar los elementos en el orden deseado
			elementosOrdenados.forEach(elemento => contenedor.appendChild(elemento));
*/
		}, 500 );

	}

//	Iniciar intervalo de actualización de los totales
	function mesa_nueva_iniciar()
	{
	//	Validar si la mesa es nueva
		mesas_actualizar_acciones();

	//	Validar si el timer esta activo
		if (mesas_timer === null)
		{
			mesas_timer = setInterval( mesas_actualizar_acciones , mesas_nueva_comparacion);
		}
	}

//	Detener intervalo de actualización de los totales
	function mesa_nueva_detener()
	{
		if (mesas_timer !== null)
		{
			clearInterval(mesas_timer);
			mesas_timer = null;
		}
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Actualizar el listado de mesas
	async function actualizarMesas()
	{
	//	Detener la validación de nuevas mesas
		mesa_nueva_detener();

	//	Solicitar la mesa asignada
		const api = await fetch( path_app + '/swich/mesas-controlador/' )
		.then( res => res.json() )
		.then( res => res || [] );

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Actualizar valores globales
		swich_modo		=	api.switch.swich_modo;
		swich_mesas		=	api.switch.swich_mesas;
		swich_mesa_1	=	api.switch.swich_mesa_1;
		swich_mesa_2	=	api.switch.swich_mesa_2;
		swich_mesa_3	=	api.switch.swich_mesa_3;
		swich_mesa_4	=	api.switch.swich_mesa_4;

	//		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

	//	Obtener el contenedor de las mesas
		const render = document.getElementById('mesas' );
		render.innerHTML = '';

	//	Iterar mesas disponibles
		api.mesas.forEach(mesa =>
		{
		//	Crear el div contenedor del candidato
			let objeto = document.createElement('article');

		//	Asignar las propiedades del div
			objeto.id = 'MES' + mesa.mesa_id
			objeto.className = `mesa mesa-swich bg-blanco box-shadow bordes-radius filtro-mesa G rojo`
			objeto.setAttribute('mesa', mesa.mesa_id);
			objeto.setAttribute('date', mesa.mesa_cambio);
			objeto.setAttribute('created', mesa.mesa_publicado);

		//	Asignar los elementos al div
			objeto.innerHTML = `<div class="mesa-nueva">NUEVA</div>
								<div id="mesa-voto-${mesa.mesa_id}" class="cambios bordes-radius"></div>
								<header>
									<h2 class="${ mesa.mesa_destacada == 1 ? 'importante' : '' }">
										<i class="fas ${ mesa.mesa_destacada == 1 ? 'fa-star' : ' fa-hashtag'}"></i> ${mesa.mesa_id}
									</h2>
									<h1 class="line-1" id="${mesa.mesa_id}_mesa_usuario"><i class="fas fa-user"></i> ${mesa.usuario_nombre}</h1>
									<div class="tipo">🔴&nbsp;&nbsp;&nbsp;PRESIDENCIALES</div>
									<div class="zona">${mesa.mesa_zona_titulo}</div>
									<h3 class="line-1" id="${mesa.mesa_id}_mesa_nombre">${mesa.mesa_local}</h3>
									<h4 class="line-1" id="${mesa.mesa_id}_mesa_numero">${mesa.mesa_numero}</h4>
									<h5 class="line-1" id="${mesa.mesa_id}_mesa_ciudad"><i class="fas fa-globe-americas"></i> ${mesa.mesa_comuna}</h5>
									<h6 class="line-1" id="${mesa.mesa_id}_mesa_cambio"><time class="timeago line-1" data="${mesa.mesa_id}" datetime="${mesa.mesa_cambio}"></time></h6>
								</header>`

		//	Crear candidato en el listado
			render.appendChild(objeto);
		});

	//	Iniciar la validación de nuevas mesas
		mesa_nueva_iniciar();

	//	Actualizar el total de mesas
		mesas_totales = api.mesas.length

	//	Actualizar el numero total de mesas en pantalla
		mesas_totales_actualizacion();
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Iniciar Funcionalidad
	pubnub.addListener(
	{
		message: function(message)
		{
		//	Obtener Nuevo Dato
			let datoPubNub			=	message.message;

		//	Obtener Accion desde PubNub
			let accion				=	datoPubNub.accion;

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Actualizar el contenido
			if( accion == 'recargar' )
			{
			//	Corrección para el Bug del salto
				setTimeout(function()
				{
				//	Actualizar Mesas del listado
					actualizarMesas();
				}, actualizar_mesas_delay );
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Voto Emitido
			if( accion == 'voto' )
			{
			//	Obtener ID de la Mesa
				const mesa_id = datoPubNub.mesa;

			//	Buscar mesa en el DOM
				const mesa_voto = document.getElementById('mesa-voto-' + mesa_id);

			//	Validar que exista el elemento
				if( mesa_voto == null )
				{
					return
				}
				else
				{
				//	Asignar clase con la animación
					mesa_voto.classList.add('animacionVotoMesa');

				//	Esperar que la animación termine
					mesa_voto.addEventListener('animationend' , function()
					{
					//	Eliminar la animación
						mesa_voto.classList.remove('animacionVotoMesa');

					//	Cambiar el color del estado
						mesa_voto.parentElement.classList.remove('verde', 'amarillo', 'rojo');
						mesa_voto.parentElement.classList.add('verde');

						const nuevo_timestamp = Math.floor(message.timetoken / 10000000)

						mesa_voto.parentElement.setAttribute( 'date' , nuevo_timestamp )

					//	Asignar Fecha actual
						const mesa_voto_date = document.getElementById(mesa_id + '_mesa_cambio');
						mesa_voto_date.innerHTML = `<time class="timeago line-1" data="${mesa_id}"  datetime="${ nuevo_timestamp }">Hace 1 segundo</time>`
					});
				}
			}
		}
	});

//	Suscribir al Canal PubNub
	pubnub.subscribe(
	{
        channels: ['vav_mesas'],
    //	withPresence: true
    });

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Actualizar el orden de las mesas
	function actualizarOrdenTimer()
	{
	//	Obtener todos los elementos con la clase 'mesa' dentro del contenedor con id 'mesas'
		const container = document.getElementById('mesas');
		const elements = Array.from(container.getElementsByClassName('mesa'));

	//	Ordenar los elementos usando la función 'actualizarOrdenMesas'
		elements.sort(actualizarOrdenMesas);

	//	Vaciar el contenedor y agregar los elementos en el nuevo orden
		elements.forEach(element => container.appendChild(element));
	}

//	Ordenar las mesas segun su actividad
	function actualizarOrdenMesas(a, b)
	{
	//	Cambiar el estado de color
		var aclass = a.className.match(estadosMesasRex);
		var avalue = aclass ? estadosMesas[aclass[0]] : 99;
		var bclass = b.className.match(estadosMesasRex);
		var bvalue = bclass ? estadosMesas[bclass[0]] : 99;
		return avalue - bvalue;
	}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

//	Estado de las mesas segun su actualización
	const estadosMesas =
	{
		rojo: 2,
		amarillo: 1,
		verde: 0
	};

//	Expresión regular de las mesas segun su actualización
	const estadosMesasRex = /(rojo|amarillo|verde)/;

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
