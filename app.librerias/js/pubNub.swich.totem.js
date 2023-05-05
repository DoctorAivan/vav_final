//	URL del diccionario de zonas
	const path_app_zonas = path_app + '/app.librerias/zonas.json?v=1.5'

//	Mode de la Aplicación
	let app_modo = 0

//	Template de Mesas
	let app_template = 0
	let app_template_historico = 0

//	Diccionario
	let objeto_regiones
	let objeto_pactos

//	Estructura de Datos
	let mesa_1 = null
	let mesa_1_candidatos = null
	let mesa_1_historico = 0
	let switch_mesa_1 = 0
	let switch_mesa_1_anterior = 0

	let mesa_2 = null
	let mesa_2_candidatos = null
	let mesa_2_historico = 0
	let switch_mesa_2 = 0
	let switch_mesa_2_anterior = 0

//	Estado Consolidados
	let mesa_totales_candidatos = null
	let mesa_totales_mesas = 0
	let mesa_totales_votos = 0
	let mesa_totales_estado = true

//	Transiciones
	let tiempo_transiciones = 750
	let tiempo_transiciones_adicional = 1000

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Render de la aplicación en el DOM
	const render = document.getElementById("render")

//	Render Fondo de Tottem
	const bg_tottem = document.getElementById("bg-tottem")

//	Render de las mesas en el DOM
	const render_mesa_1 = document.getElementById("render-mesa-1")
	const render_mesa_2 = document.getElementById("render-mesa-2")
	const render_mesa_totales = document.getElementById("render-mesa-totales")

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Posicion de los Elementos en las Animaciones

//	Cordenadas de la Mesa 1
	const mesa_1_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : '133px',
				'y' : '195px',
				'z' : 'unset'
			//	'z' : 'rotateY(0deg)'
			},
			'oculta' : {
				'x' : '-340px',
				'y' : '195px',
				'z' : 'unset'
			//	'z' : 'rotateY(112deg)'
			}
		},
		'template_floating' : {
			'visible' : {
				'x' : '133px',
				'y' : '195px',
				'z' : 'unset'
			//	'z' : 'rotateY(0deg)'
			},
			'oculta' : {
				'x' : '-340px',
				'y' : '195px',
				'z' : 'unset'
			//	'z' : 'rotateY(112deg)'
			}
		}
	}

//	Cordenadas de la Mesa 2
	const mesa_2_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : '133px',
				'y' : '610px',
				'z' : 'unset'
			//	'z' : 'rotateY(0deg)'
			},
			'oculta' : {
				'x' : '-340px',
				'y' : '610px',
				'z' : 'unset'
			//	'z' : 'rotateY(112deg)'
			}
		},
		'template_floating' : {
			'visible' : {
				'x' : '1446px',
				'y' : '195px',
				'z' : 'unset'
			//	'z' : 'rotateY(0deg)'
			},
			'oculta' : {
				'x' : '1920px',
				'y' : '195px',
				'z' : 'unset'
			//	'z' : 'rotateY(-90deg)'
			}
		}
	}

//	Cordenadas de la Mesa Totales
	const mesa_totales_cordenadas = {
		'visible' : {
			'x' : '1446px',
			'y' : '195px',
			'z' : 'unset'
		},
		'oculta' : {
			'x' : '1920px',
			'y' : '195px',
			'z' : 'unset'
		}
	}
	
//	Cordenadas del fondo de Tottem
	const bg_tottem_cordenadas = {
		'mesas_0' : {
			'h' : '0px'
		},
		'mesas_1' : {
		//	'h' : '439px'
			'h' : '912px'
		},
		'mesas_2' : {
			'h' : '912px'
		}
	}

//	Titulo Mesa Conteo
	const mesa_titulo = 'VOTO A VOTO'

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Iniciar PubNub
	pubnub.addListener(
	{
	//	Recibir Mensajes
		message: function(message)
		{
		//	Obtener Nuevo Dato
			let datoPubNub			=	message.message;

		//	Obtener Accion desde PubNub
			let accion				=	datoPubNub.accion;

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Cambio de switch
			if( accion == 'switch' )
			{
			//	Asignar los ID de las Mesas enviadas
				switch_mesa_1 = datoPubNub.mesa_1
				switch_mesa_2 = datoPubNub.mesa_2

			//	Validar que exista cambio de template
				if( app_modo == datoPubNub.modo )
				{
				//	Validar que la mesa 1 sea distinta a la actual
				//	if( switch_mesa_1 != switch_mesa_1_anterior || app_template != datoPubNub.template )
					if( switch_mesa_1 != switch_mesa_1_anterior || datoPubNub.template == 0 )
					{
						App.animar_salida_mesa_1( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_1 )
					}
	
				//	Validar que la mesa 2 sea distinta a la actual
					if( switch_mesa_2 != switch_mesa_2_anterior || app_template != datoPubNub.template )
					{
						App.animar_salida_mesa_2( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_2 )
					}

				//	Dibujar mesas en la escena
					setTimeout(function()
					{
					//	Iniciar Animaciones
						App.init();
					}, tiempo_transiciones_adicional );

					console.log('switch IF');
				}
				else
				{
					console.log('switch ELSE');

				//	Reiniciar ID Historicos
					mesa_1_historico = 0
					mesa_2_historico = 0

				//	Animar la salida del bloque
					App.animar_salida_mesa_1( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_1 )
					App.animar_salida_mesa_2( datoPubNub.template , datoPubNub.modo , datoPubNub.mesa_2 )

				//	Dibujar mesas en la escena
					setTimeout(function()
					{
					//	Iniciar Animaciones
						App.init();
					}, tiempo_transiciones_adicional );

				//	Almacenar el Template actual
					app_modo = datoPubNub.modo
				}

			//	Almacenar el Template actual
				app_template = datoPubNub.template

			// Validar el template
				if( datoPubNub.template == 0 )
				{
				//	Mesa totales en la Escena
					setTimeout(function()
					{
						bg_tottem.style.left = '-473px';
					}, tiempo_transiciones );
				}
				else if( datoPubNub.template == 1 )
				{
				//	Mesa totales en la Escena
					setTimeout(function()
					{
						bg_tottem.style.left = '0px';
						bg_tottem.style.height = bg_tottem_cordenadas.mesas_1.h;
					}, tiempo_transiciones );
				}
				else if( datoPubNub.template == 2 )
				{
				//	Mesa totales en la Escena
					setTimeout(function()
					{
						bg_tottem.style.left = '0px';
						bg_tottem.style.height = bg_tottem_cordenadas.mesas_2.h;
					}, tiempo_transiciones );
				}

				if( datoPubNub.modo == 1 )
				{
				//	Mesa totales en la Escena
					setTimeout(function()
					{
						bg_tottem.style.left = '-473px';
					}, tiempo_transiciones );
				}
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Voto Emitido
			if( accion == 'voto' )
			{
			//	Variables necesarias
				let id = datoPubNub.id
				let voto = datoPubNub.valor
				let mesa = datoPubNub.mesa
				let candidato = datoPubNub.candidato
				let accion_voto = datoPubNub.accion_voto

			//	Validar que el voto emitido este en pantalla
				App.voto( id , mesa , candidato , voto );

			//	Sumer votos a la mesa de consolidados
				App.voto_totales( candidato , voto , accion_voto );
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

			//	Accion : Estado consolidados
			if( accion == 'cons_estado' )
			{
			//	Variables necesarias
				let estado = datoPubNub.estado

			//	Validar estado del Modulo
				if( estado == 'on' )
				{
					mesa_totales_estado = true

					App.totales();
				}
				else
				{
					mesa_totales_estado = false
					
					App.animar_salida_totales()
				}
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Actualizar conteo total
			if( accion == 'recargar' )
			{
			//	Actualizar mesa totales
				App.totales_actualizar()
			}

		}
	});

//	Suscribirse al Canal
	pubnub.subscribe(
	{
		channels: ['vav_mesas'],
		withPresence: true
	});

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Constructor de la Aplicación
	const App =
	{
	//	Mesa con resultados totales
		totales : async function()
		{
		//	Solicitar la mesa asignada
			const api = await fetch( path_app + '/swich/mesas-totales/' )
			.then( res => res.json() )
			.then( res => res || [] );

			mesa_totales_mesas = api.mesas
			mesa_totales_votos = api.votos

		//	Almacenar listado de candidatos para gestionar actualizacion
			mesa_totales_candidatos = api.candidatos

		//	Dibujar la mesa en el DOM
			App.totales_draw();

		//	Mostrar el pantalla
			App.animar_entrada_totales();
		},

	//	Mesa con resultados totales
		totales_actualizar : async function()
		{
		//	Solicitar la mesa asignada
			const api = await fetch( path_app + '/swich/mesas-totales/' )
			.then( res => res.json() )
			.then( res => res || [] );

			mesa_totales_mesas = api.mesas
			mesa_totales_votos = api.votos

		//	Almacenar listado de candidatos para gestionar actualizacion
			mesa_totales_candidatos = api.candidatos

		//	Dibujar la mesa en el DOM
			App.ordenar_votos_totales();

		//	Obtener valor del voto
			const mesa_totales_detalles = document.getElementById('mesa-totales-detalles');
			mesa_totales_detalles.innerHTML = `${mesa_totales_mesas} MESAS&ensp;-&ensp;${App.numero(mesa_totales_votos)} VOTOS`
		},

	//	Dibujar la mesa en el DOM
		totales_draw : function()
		{
        //  DIV render en el DOM
			const render	=	document.getElementById('render-mesa-totales' );

		//	Vaciar el contenedor
			render.innerHTML = '';

		//	Crear el DIV de la mesa
			let div_mesa = document.createElement('div');
			div_mesa.id = 'mesa-0'

			//	Asignar las clases a la mesa
			div_mesa.className = `box totales mesa-doble`

		//	Crear elementos en el DIV
			div_mesa.innerHTML =   `<div class="title">
										<h2>REG. METROPOLITANA</h2>
									</div>
									<div class="header">
										<h3>CONSOLIDADOS VOTO A VOTO</h3>
										<h4 id="mesa-totales-detalles"><b>${mesa_totales_mesas} MESAS</b>&ensp;-&ensp;${App.numero(mesa_totales_votos)} VOTOS</h4>
									</div>
									<div class="columns" id="mesa-0-candidatos"></div>`;

        //	Dibujar la Mesa en el DOM
			render.appendChild(div_mesa);

		//	Render de los candidatos en la mesa
			const render_candidatos = document.getElementById('mesa-0-candidatos');

		//	Indice del orden
			let id_orden = 1;

		//	Ordenar los candidatos por sus votos
			mesa_totales_candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.objeto > b.objeto) ? 1 : -1) : -1 )

        //	Recorrer el listado de candidatos
			mesa_totales_candidatos.forEach(candidato =>
            {
            //	Crear el div contenedor del candidato
                let objeto = document.createElement('div');
				objeto.className = `candidato order-${id_orden} no-electo`

            //	Asignar las propiedades del div
                objeto.id = 'candidate-' + candidato.id

			//	Asignar los elementos al div
				objeto.innerHTML = `<div class="candidato-detalles">
										<h2>${candidato.nombres} ${candidato.apellidos}</h2>
										<h3><span>${candidato.pacto} /</span>
										${ candidato.ind === 't' ?
										candidato.partido_id == 99 ? '' : 'IND-'
										:
										''
										}${candidato.partido}</h3>
									</div>
									<div class="candidato-votos">
										<div id="candidato-${candidato.id}-votos" class="candidato-votos-valor">
											${App.numero(candidato.votos)}
										</div>
										<div class="candidato-votos-animacion"></div>
									</div>`

            //	Crear candidato en el listado
				render_candidatos.appendChild(objeto);

			//	Limitar el orden de los candidatos
				id_orden <= 5 && id_orden++
            });
		},

	//	Animar la entrada del bloque
		animar_entrada_totales : function()
		{
			console.log('> animar_entrada_totales');

		//	Validar mesas antes de desplegar
			if( app_modo == 1 && mesa_2 != null )
			{
			//	Quitar la Mesa 2
				App.animar_salida_mesa_2();

			//	Corrección para el Bug del salto
				setTimeout(function()
				{
				//	Asignar Posiciones en el eje X
					render_mesa_totales.style.bottom = mesa_totales_cordenadas.visible.y;
					render_mesa_totales.style.left = mesa_totales_cordenadas.visible.x;
					render_mesa_totales.style.transform = mesa_totales_cordenadas.visible.z;

					mesa_totales_estado = true;

				}, tiempo_transiciones_adicional );
			}
			else
			{
			//	Asignar Posiciones en el eje X
				render_mesa_totales.style.bottom = mesa_totales_cordenadas.visible.y;
				render_mesa_totales.style.left = mesa_totales_cordenadas.visible.x;
				render_mesa_totales.style.transform = mesa_totales_cordenadas.visible.z;

				mesa_totales_estado = true;
			}
		},

	//	Animar la entrada del bloque
		animar_salida_totales : function()
		{
			console.log('< animar_salida_totales');

		//	Asignar Posiciones en el eje X
			render_mesa_totales.style.bottom = mesa_totales_cordenadas.oculta.y;
			render_mesa_totales.style.left = mesa_totales_cordenadas.oculta.x;
			render_mesa_totales.style.transform = mesa_totales_cordenadas.oculta.z;

			mesa_totales_estado = false;

			//	Corrección para el Bug del salto
			setTimeout(function()
			{
			//	Validar mesas antes de desplegar
				if( app_modo == 1 && mesa_totales_estado == false && mesa_2 != null )
				{
					App.animar_entrada_mesa_2();
				}

			}, tiempo_transiciones_adicional );
		},

	//	Asignar votos a la mesa de consolidados
		voto_totales : function( candidato , voto , accion )
		{
		//	Obtener el candidato desde el listado
			let candidato_obj = mesa_totales_candidatos.find(({ id }) => id === candidato);
		
		//	Validar que el candidato exista
			if( candidato_obj )
			{
			//	Actualizar un voto
				if( accion == 'g' )
				{
				//	Actualizar mesa totales
					App.totales_actualizar()
					return
				}

			//	Sumar un voto
				else if( accion == 's' )
				{
				//	Actualizar el voto en el listado
					candidato_obj.votos += 1

				//	Actualizar el total de votos
					mesa_totales_votos += 1
				}

			//	Restar un voto
				else if( accion == 'r' )
				{
				//	Validar que el voto no sea cero
					if( voto != 0 )
					{
					//	Actualizar el voto en el listado
						candidato_obj.votos -= 1

					//	Actualizar el total de votos
						mesa_totales_votos -= 1
					}
					else
					{
					//	Actualizar mesa totales
						App.totales_actualizar()
						return
					}
				}

			//	Obtener valor del voto
				const mesa_totales_detalles = document.getElementById('mesa-totales-detalles');
				mesa_totales_detalles.innerHTML = `${mesa_totales_mesas} MESAS&ensp;-&ensp;${App.numero(mesa_totales_votos)} VOTOS`

			//	Actualizar votos en el DOM
				const candidato_voto = document.getElementById('candidate-' + candidato);

			//	Validar que exista el elemento
				if( candidato_voto != null )
				{
					const candidato_div_voto_valor = document.querySelector( '#candidate-' + candidato + ' > div.candidato-votos > div.candidato-votos-valor' );
					candidato_div_voto_valor.classList.add('animar_voto_texto')
	
				//	Identificar el contenedor del cambio de voto
					const candidato_div_voto_animacion = document.querySelector( '#candidate-' + candidato + ' > div.candidato-votos > div.candidato-votos-animacion' );
					candidato_div_voto_animacion.classList.add('animar_voto');
	
				//	Reiniciar animación del voto
					setTimeout(function()
					{
						candidato_div_voto_valor.classList.remove('animar_voto_texto');
						candidato_div_voto_animacion.classList.remove('animar_voto');
						
					}, tiempo_transiciones_adicional);
	
				//	Actualizar los valores
					setTimeout(function()
					{
						candidato_div_voto_valor.innerHTML = App.numero(candidato_obj.votos);
					}, 500);

					App.ordenar_votos_totales();
				}
			}
		},

	//	Ordenar Votos de los candidatos
		ordenar_votos_totales : function ()
		{
		//	Ordenar los candidatos por sus votos
			mesa_totales_candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.objeto > b.objeto) ? 1 : -1) : -1 )

		//	Orden del candidato
			let id_orden = 1;

		//	Iterar listado de candidatos
			mesa_totales_candidatos.forEach(candidato =>
			{
			//  Get object from DOM
				const candidato_div = document.getElementById(`candidate-${candidato.id}`);
				candidato_div.classList = `candidato order-${id_orden} no-electo`;

				//	Obtener valor del voto
				const candidato_voto_valor = document.getElementById(`candidato-${candidato.id}-votos`);
				candidato_voto_valor.innerHTML = App.numero(candidato.votos);

				id_orden <= 5 && id_orden++
			});
		},

	//			-			-			-			-			-			-			-			-			-			-			-

	//	Crear diccionarios
		zone : async function()
		{
		//	Solicitar la mesa asignada
			const api = await fetch( path_app_zonas )
			.then( res => res.json() )
			.then( res => res || [] );

		//	Generar diccionario
			objeto_regiones = api.regiones
			objeto_pactos = api.pactos
		},

	//	Iniciar la App
		init : async function()
		{
		//	Solicitar la mesa asignada
			const api = await fetch( path_app + '/swich/mesas-actuales/' )
			.then( res => res.json() )
			.then( res => res.mesas || [] );

		//	Asignar modo de render
			if( app_modo == 0 )
			{
			//	Asignar clase al modo
				render_mesa_1.classList.remove('floating');
				render_mesa_1.classList.add('tottem');

				render_mesa_2.classList.remove('floating');
				render_mesa_2.classList.add('tottem');
			}
			else if( app_modo == 1 )
			{
				//	Asignar clase al modo
				render_mesa_1.classList.remove('floating');
				render_mesa_1.classList.add('tottem');

				render_mesa_2.classList.remove('floating');
				render_mesa_2.classList.add('tottem');
			}

		//	Validar que exista la Mesa 1
			if( switch_mesa_1 != null )
			{
			//	Obtener la primera mesa
				mesa_1 = api[switch_mesa_1];

			//	Asignar Cupos por región
				mesa_1.cupos = App.obtener_cupos(mesa_1.zona_id);

				//	Validar Rendereo de la mesa con Historicos
				if( mesa_1_historico != mesa_1.id || app_template_historico != app_template )
				{
				//	Obtener los candidatos de la mesa
					mesa_1_candidatos = mesa_1.candidatos;

				//	Dibujar la mesa en el DOM		
					App.draw( 1 , mesa_1 );
				}
			}

		//	Validar que el template sea compatible
			if( app_template == 2 )
			{
			//	Asignar clase al modo
				render_mesa_1.classList.remove('template-1');
				render_mesa_1.classList.add('template-2');

			//	Asignar clase al modo
				render_mesa_2.classList.remove('template-1');
				render_mesa_2.classList.add('template-2');

			//	Validar que exista la Mesa 2
				if( switch_mesa_2 != null )
				{
				//	Obtener la primera mesa
					mesa_2 = api[switch_mesa_2];

				//	Asignar Cupos por región
					mesa_2.cupos = App.obtener_cupos(mesa_2.zona_id);

				//	Validar Rendereo de la mesa con Historicos
					if( mesa_2_historico != mesa_2.id || app_template_historico != app_template )
					{
					//	Obtener los candidatos de la mesa
						mesa_2_candidatos = mesa_2.candidatos;

					//	Validar template anterior
						if( app_modo == 0 )
						{
						//	Reiniciar Mesa
							render_mesa_2.classList.remove('transition-on')
							render_mesa_2.style.bottom = mesa_2_cordenadas.template_tottem.oculta.y;
							render_mesa_2.style.left = mesa_2_cordenadas.template_tottem.oculta.x;
							render_mesa_2.style.transform = mesa_2_cordenadas.template_tottem.oculta.z;
						}

					//	Validar template anterior
						if( app_modo == 1 )
						{
						//	Reiniciar Mesa
							render_mesa_2.classList.remove('transition-on')	
							render_mesa_2.style.bottom = mesa_2_cordenadas.template_floating.oculta.y;
							render_mesa_2.style.left = mesa_2_cordenadas.template_floating.oculta.x;
							render_mesa_2.style.transform = mesa_2_cordenadas.template_floating.oculta.z;
						}

					//	Dibujar la mesa en el DOM		
						App.draw( 2 , mesa_2 );
					}
				}
			}
			else
			{
			//	Vaciar el contenedor
				render_mesa_2.innerHTML = ''

			//	Asignar clase al modo
				render_mesa_1.classList.remove('template-2');
				render_mesa_1.classList.add('template-1');

			//	Asignar clase al modo
				render_mesa_2.classList.remove('template-2');
				render_mesa_2.classList.add('template-1');
			}

		//	Almacenar ID Historico de la Mesa
			if( api[switch_mesa_1] )
			{
				mesa_1_historico = api[switch_mesa_1].id
			}

			if( api[switch_mesa_2] )
			{
				mesa_2_historico = api[switch_mesa_2].id
			}

		//	Almacenar Template
			app_template_historico = app_template
		},

	//	Dibujar la mesa en el DOM
		draw : function( posicion , mesa )
		{
		//	Obtener información de la Región
		//	const region = objeto_regiones.find(({ i }) => i === Number(mesa.zona_id));

        //  DIV render en el DOM
            const render	=	document.getElementById('render-mesa-' + posicion );

		//	Vaciar el contenedor
			render.innerHTML = '';

		//	Crear el DIV de la mesa
			let div_mesa = document.createElement('div');
			div_mesa.id = 'mesa-' + mesa.id

			//	Asignar las clases a la mesa
			div_mesa.className = `box pos-${posicion} mesa-doble`

		//	Crear elementos en el DIV
			div_mesa.innerHTML =   `<div class="title">
										<h2>${mesa.comuna}</h2>
									</div>
									<div class="header">
										<h3>${mesa.local}</h3>
										<h4>${mesa.numero}</h4>
									</div>
									<div class="columns" id="mesa-${mesa.id}-candidatos"></div>`;

        //	Dibujar la Mesa en el DOM
			render.appendChild(div_mesa);

		//	Render de los candidatos en la mesa
			const render_candidatos = document.getElementById('mesa-' + mesa.id + '-candidatos');

		//	Indice del orden
			let id_orden = 1;

		//	Ordenar los candidatos por sus votos
			mesa.candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.objeto > b.objeto) ? 1 : -1) : -1 )

        //	Recorrer el listado de candidatos
			mesa.candidatos.forEach(candidato =>
            {
            //	Crear el div contenedor del candidato
                let objeto = document.createElement('div');
				objeto.className = `candidato order-${id_orden} no-electo`

            //	Asignar las propiedades del div
                objeto.id = 'candidate-' + candidato.objeto

			//	Asignar los elementos al div
				objeto.innerHTML = `<div class="candidato-detalles">
										<h2>${candidato.nombres} ${candidato.apellidos}</h2>
										<h3><span>${candidato.pacto} /</span>
										${ candidato.ind === 't' ?
										candidato.partido_id == 99 ? '' : 'IND-'
										:
										''
										}${candidato.partido}</h3>
									</div>
									<div class="candidato-votos">
										<div id="candidato-${candidato.objeto}-votos" class="candidato-votos-valor">
											${candidato.votos}
										</div>
										<div class="candidato-votos-animacion"></div>
									</div>`

            //	Crear candidato en el listado
				render_candidatos.appendChild(objeto);

			//	Maximo de Candidatos
				id_orden <= 5 && id_orden++
            });

		//	Asignar posición 2 en pantalla
			if( posicion == 1 )
			{
				if( app_template != 0 )
				{
					App.animar_entrada_mesa_1();
				}
			}

		//	Asignar posición 2 en pantalla
			if( posicion == 2 )
			{
				if( app_template != 0 )
				{
					App.animar_entrada_mesa_2();
				}
			}
		},

	//	Asignar votos a un candidato
		voto : function( id , mesa, candidato, votos )
		{
		//	Actualizar votos en el DOM
			const candidato_voto = document.getElementById(`candidate-${id}`);

		//	Validar que exista el elemento
			if( candidato_voto != null )
			{
				const candidato_div_voto_valor = document.querySelector('#candidate-' + id + ' > div.candidato-votos > div.candidato-votos-valor');
				candidato_div_voto_valor.classList.add('animar_voto_texto')

			//	Identificar el contenedor del cambio de voto
				const candidato_div_voto_animacion = document.querySelector('#candidate-' + id + ' > div.candidato-votos > div.candidato-votos-animacion');
				candidato_div_voto_animacion.classList.add('animar_voto');

			//	Reiniciar animación del voto
				setTimeout(function()
				{
					candidato_div_voto_valor.classList.remove('animar_voto_texto');
					candidato_div_voto_animacion.classList.remove('animar_voto');
					
				}, tiempo_transiciones_adicional);

			//	Actualizar los valores
				setTimeout(function()
				{
					candidato_div_voto_valor.innerHTML = votos;
				}, 500);

				if( mesa_1 )
				{
					if( mesa == mesa_1.id)
					{
						const result = mesa_1.candidatos.find(({ objeto }) => objeto === id);
						result.votos = votos;
	
						App.ordenar_votos(mesa);
					}
				}

				if( mesa_2 )
				{
					if( mesa == mesa_2.id)
					{
						const result = mesa_2.candidatos.find(({ objeto }) => objeto === id);
						result.votos = votos;
	
						App.ordenar_votos(mesa);
					}
				}
			}
			else
			{
				console.log('NO RENDER');
			}
		},

	//	Ordenar Votos de los candidatos
		ordenar_votos : function (mesa)
		{
		//	Mesa Candidatos por cambiar
			let mesa_candidatos

		//	Validar si existe mesa 1
			if( mesa_1 )
			{
				if( mesa == mesa_1.id )
				{
				//	Ordenar los candidatos por sus votos
					mesa_1.candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.objeto > b.objeto) ? 1 : -1) : -1 )
	
				//	Guardar Mesa
					mesa_candidatos = mesa_1.candidatos;
				}
			}

		//	Validar si existe mesa 1
			if( mesa_2 )
			{
				if( mesa == mesa_2.id )
				{
				//	Ordenar los candidatos por sus votos
					mesa_2.candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.objeto > b.objeto) ? 1 : -1) : -1 )

				//	Guardar Mesa
					mesa_candidatos = mesa_2.candidatos;
				}
			}

		//	Orden del candidato
			let id_orden = 1;

        //	Iterar listado de candidatos
			mesa_candidatos.forEach(candidato =>
            {
			//  Get object from DOM
				let candidato_div = document.getElementById(`candidate-${candidato.objeto}`);
				candidato_div.classList = `candidato order-${id_orden} no-electo`;

			//	Validar Posicion de los Objetos
				id_orden <= 5 && id_orden++
			});
		},

	//			-			-			-			-			-			-			-			-			-			-			-

	//	Animar la entrada del bloque
		animar_entrada_mesa_1 : function()
		{
		//	Template Totem
			if( app_modo == 0 )
			{
			//	Asignar Posiciones en el eje X
				render_mesa_1.style.bottom = mesa_1_cordenadas.template_tottem.visible.y;
				render_mesa_1.style.left = mesa_1_cordenadas.template_tottem.visible.x;
				render_mesa_1.style.transform = mesa_1_cordenadas.template_tottem.visible.z;
			}

		//	Template Floating
			if( app_modo == 1 )
			{
			//	Asignar Posiciones en el eje X
				render_mesa_1.style.bottom = mesa_1_cordenadas.template_floating.visible.y;
				render_mesa_1.style.left = mesa_1_cordenadas.template_floating.visible.x;
				render_mesa_1.style.transform = mesa_1_cordenadas.template_floating.visible.z;
			}
		},

	//	Animar la entrada del bloque
		animar_entrada_mesa_2 : function()
		{
		//	Validar mesas antes de desplegar
			if( mesa_totales_estado == true && app_modo == 1 )
			{
			//	Quitar Mesa de totales
				App.animar_salida_totales()

			//	Corrección para el Bug del salto
				setTimeout(function()
				{
					render_mesa_2.classList.add('transition-on')

				//	Asignar Posiciones en el eje X
					render_mesa_2.style.bottom = mesa_2_cordenadas.template_floating.visible.y;
					render_mesa_2.style.left = mesa_2_cordenadas.template_floating.visible.x;
					render_mesa_2.style.transform = mesa_2_cordenadas.template_floating.visible.z;

				}, tiempo_transiciones_adicional );			
			}
			else
			{
			//	Corrección para el Bug del salto
				setTimeout(function()
				{
					render_mesa_2.classList.add('transition-on')

					//	Template Totem
					if( app_modo == 0 )
					{
					//	Asignar Posiciones en el eje X
						render_mesa_2.style.bottom = mesa_2_cordenadas.template_tottem.visible.y;
						render_mesa_2.style.left = mesa_2_cordenadas.template_tottem.visible.x;
						render_mesa_2.style.transform = mesa_2_cordenadas.template_tottem.visible.z;
					}

				//	Template Floating
					if( app_modo == 1 )
					{
					//	Asignar Posiciones en el eje X
						render_mesa_2.style.bottom = mesa_2_cordenadas.template_floating.visible.y;
						render_mesa_2.style.left = mesa_2_cordenadas.template_floating.visible.x;
						render_mesa_2.style.transform = mesa_2_cordenadas.template_floating.visible.z;
					}
				}, tiempo_transiciones_adicional / 4);				
			}
		},

	//			-			-			-			-			-			-			-			-			-			-			-

	//	Animar la entrada del bloque
		animar_salida_mesa_1 : function( template , modo , mesa_id )
		{
		//	Template Totem
			if( app_modo == 0 )
			{
				render_mesa_1.style.bottom = mesa_1_cordenadas.template_tottem.oculta.y;
				render_mesa_1.style.left = mesa_1_cordenadas.template_tottem.oculta.x;
				render_mesa_1.style.transform = mesa_1_cordenadas.template_tottem.oculta.z;
			}

		//	Template Floating
			if( app_modo == 1 )
			{
				render_mesa_1.style.bottom = mesa_1_cordenadas.template_floating.oculta.y;
				render_mesa_1.style.left = mesa_1_cordenadas.template_floating.oculta.x;
				render_mesa_1.style.transform = mesa_1_cordenadas.template_floating.oculta.z;
			}

		//	Validar que exista un mesa que mostrar
			if( mesa_id != null )
			{
			//	Asignar mesa anterior
				switch_mesa_1_anterior = mesa_id

			//	Reiniciar animación del voto
				setTimeout(function()
				{
				//	Asignar mode del Render
					app_modo = modo;

				}, tiempo_transiciones_adicional );
			}
			else
			{
			//	Limpiar mesa
				setTimeout(function()
				{
				//	Limpiar el Objeto
					mesa_1 = null

				//	Limpiar el DOM
					render_mesa_1.innerHTML = ''

				}, tiempo_transiciones_adicional );
			}

			mesa_1_historico = 0
		},

	//	Animar la entrada del bloque
		animar_salida_mesa_2 : function( template , modo , mesa_id )
		{
		//	Template Totem
			if( app_modo == 0 )
			{
			//	Asignar Posiciones en el eje X
				render_mesa_2.style.bottom = mesa_2_cordenadas.template_tottem.oculta.y;
				render_mesa_2.style.left = mesa_2_cordenadas.template_tottem.oculta.x;
				render_mesa_2.style.transform = mesa_2_cordenadas.template_tottem.oculta.z;
			}

		//	Template Floating
			if( app_modo == 1 )
			{
			//	Asignar Posiciones en el eje X
				render_mesa_2.style.bottom = mesa_2_cordenadas.template_floating.oculta.y;
				render_mesa_2.style.left = mesa_2_cordenadas.template_floating.oculta.x;
				render_mesa_2.style.transform = mesa_2_cordenadas.template_floating.oculta.z;
			}

		//	Validar que exista un mesa que mostrar
			if( mesa_id != null )
			{
			//	Asignar mesa anterior
				switch_mesa_2_anterior = mesa_id

			//	Reiniciar animación del voto
				setTimeout(function()
				{
				//	Asignar mode del Render
					app_modo = modo;

				}, tiempo_transiciones_adicional );
			}
			else
			{
			//	Limpiar mesa
				setTimeout(function()
				{
				//	Limpiar el Objeto
				//	mesa_2 = null

				//	Limpiar el DOM
				//	render_mesa_2.innerHTML = ''

				}, tiempo_transiciones_adicional );
			}

			mesa_2_historico = 0
		},

	//	Obtener los cupos disponibles en la región
		obtener_cupos : function ( id )
		{
		//	Obtener información de la Región
			const region = objeto_regiones.find(({ i }) => i === Number(id));
			
		//	Cupos de los candidatos por región
			const cupos_region = region.c;

		//	Retornar los cupos
			return cupos_region
		},

	//	Agregar miles a los numeros
		numero : function( valor )
		{
			return new Intl.NumberFormat('en-DE').format(valor);
		}

	}

//	Iniciar las Zonas
	App.zone();

//	Iniciar Totales
	App.totales();