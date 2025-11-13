//	URL del diccionario de zonas
	const path_app_zonas = path_app + '/app.librerias/zonas.json?v=4.3'

//	Mode de la Aplicación
	let app_modo = 0

//	Template de Mesas
	let app_template = 0
	let app_template_historico = 0

//	Diccionario
	let objeto_regiones
	let objeto_provincias
	let objeto_comunas
	let objeto_circunscripciones
	let objeto_distritos
	let objeto_pactos
	let objeto_partidos

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
	let mesa_totales_estado = false
	let mesa_totales_iniciado = false
	let mesa_totales_tipo = ''
	let mesa_totales_posicion = ''
	let mesa_totales_cantidad = ''
	let mesa_totales_zona = 0
	let mesa_totales_timer = null

//	Cantidad maxima de candidatos por listado
	const cantidad_maxima_candidatos = 8

//	Intervalo de actualización de consolidados
	const mesa_totales_intervalo = 3000

//	Transiciones
	const tiempo_transiciones = 600
	const tiempo_transiciones_adicional = 1000

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	URL del repositorio de las imagenes
	const path_imagenes = path_app + '/app.imagenes/'
	const path_imagenes_candidatos = path_imagenes + 'candidatos/'
	const path_imagenes_candidatos_error = path_imagenes + 'candidatos/000.png?v=2.6'

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Render de la aplicación en el DOM
	const render = document.getElementById("render")

//	Render de las mesas en el DOM
	const render_mesa_1 = document.getElementById("render-mesa-1")
	const render_mesa_2 = document.getElementById("render-mesa-2")
	const render_mesa_totales = document.getElementById("render-mesa-totales")

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Contenedor de pantalla Full HD
	const contenedor_tv_ancho = 1920;
	const contenedor_tv_alto = 1080;

//	Contenedor de los candidatos
	const candidato_contenedor_ancho = 295;
	const candidato_contenedor_separacion_x = 0;
	const candidato_contenedor_separacion_y = 270; //178

//	Cordenadas de la Mesa 1
	const mesa_1_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : candidato_contenedor_separacion_x + 'px',
				'y' : candidato_contenedor_separacion_y + 'px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : ( candidato_contenedor_ancho * -1) + 'px',
				'y' : candidato_contenedor_separacion_y + 'px',
				'z' : 'unset'
			}
		},
		'template_floating' : {
			'visible' : {
				'x' : candidato_contenedor_separacion_x + 'px',
				'y' : candidato_contenedor_separacion_y + 'px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : ( candidato_contenedor_ancho * -1) + 'px',
				'y' : candidato_contenedor_separacion_y + 'px',
				'z' : 'unset'
			}
		}
	}

//	Cordenadas de la Mesa 2
	const mesa_2_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : ( contenedor_tv_ancho - candidato_contenedor_ancho - candidato_contenedor_separacion_x ) + 'px',
				'y' : candidato_contenedor_separacion_y + 'px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : contenedor_tv_ancho + 'px',
				'y' : candidato_contenedor_separacion_y + 'px',
				'z' : 'unset'
			}
		},
		'template_floating' : {
			'visible' : {
				'x' : ( contenedor_tv_ancho - candidato_contenedor_ancho - candidato_contenedor_separacion_x ) + 'px',
				'y' : candidato_contenedor_separacion_y + 'px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : contenedor_tv_ancho + 'px',
				'y' : candidato_contenedor_separacion_y + 'px',
				'z' : 'unset'
			}
		}
	}

//	Cordenadas de la Mesa Totales
	const mesa_totales_cordenadas = {
		'template_tottem' : {
			'visible' : {
				'x' : '0px',
				'y' : '0px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : '0px',
				'y' : '0px',
				'z' : 'unset'
			}
		},
		'template_floating' : {
			'visible' : {
				'x' : '0px',
				'y' : '885px',
				'z' : 'unset'
			},
			'oculta' : {
				'x' : '0px',
				'y' : '1150px',
				'z' : 'unset'
			}
		}
	}

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Iniciar PubNub
	pubnub.addListener(
	{
	//	Recibir Mensajes
		message: function(message)
		{
		//	Obtener Nuevo Dato
			const datoPubNub			=	message.message;

		//	Obtener Accion desde PubNub
			const accion				=	datoPubNub.accion;

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
					}, tiempo_transiciones );
				}
				else
				{
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
					}, tiempo_transiciones );

				//	Almacenar el Template actual
					app_modo = datoPubNub.modo
				}

			//	Almacenar el Template actual
				app_template = datoPubNub.template
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Accion : Voto Emitido
			if( accion == 'voto' )
			{
			//	Variables necesarias
				const id = datoPubNub.id
				const voto = datoPubNub.valor
				const mesa = datoPubNub.mesa
				const candidato = datoPubNub.candidato

			//	Validar que el voto emitido este en pantalla
				App.voto( id , mesa , candidato , voto );
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

			//	Accion : Estado consolidados
			if( accion == 'cons_estado' )
			{
			//	Variables necesarias
				const estado = datoPubNub.estado

			//	Cantidad de candidatos
				mesa_totales_cantidad = datoPubNub.position

			//	Validar estado del Modulo
				if( estado == 'on' )
				{
					App.totales();
				}
				else
				{
				//	Detener el Intervalo de actualización
					App.totales_actualizacion_detener();

				//	Iniciar animación de salida
					App.animar_salida_totales();

				//	Actualizar el valor
					mesa_totales_estado = false
				}
			}

		//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

			//	Accion : Consolidados template
			if( accion == 'cons_template' )
			{
			//	Cantidad de candidatos
				mesa_totales_cantidad = datoPubNub.position;

			//	Validar que consolidados este activo
				if( mesa_totales_estado )
				{
					App.totales_draw();
				}
			}
		}
	});

//	Suscribirse al Canal
	pubnub.subscribe(
	{
		channels: ['vav_mesas'],
	//	withPresence: true
	});

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	Constructor de la Aplicación
	const App =
	{
	//	Iniciar intervalo de actualización de los totales
		totales_actualizacion_iniciar : () =>
		{
			if (mesa_totales_timer === null)
			{
				mesa_totales_timer = setInterval(App.totales_actualizar, mesa_totales_intervalo);
			
			//	Actualizar
				App.actualizar_reloj();
			}
		},

	//	Detener intervalo de actualización de los totales
		totales_actualizacion_detener : () =>
		{
			if (mesa_totales_timer !== null)
			{
				clearInterval(mesa_totales_timer);
				mesa_totales_timer = null;
			}
		},

	//	Generar interpolación entre el valor actual y final
		totales_actualizacion_votos : (element, newValue, duration) =>
		{
		//	Obtener del DOM el valor actual
			const startValue = Number(element.innerText.replace(',','.'));
			const newValueFormated = Number(newValue);
		
		//	Validar cambio en los votos
			if( startValue === newValueFormated )
			{
				return
			}
			else
			{
				const increment = newValue - startValue;
				const startTime = performance.now();
			
				function update(currentTime)
				{
					const elapsedTime = currentTime - startTime;
					const progress = Math.min(elapsedTime / duration, 1);
					const currentValue = startValue + increment * progress;

					element.innerText = currentValue.toFixed(2).replace('.',',');
					
					if (progress < 1)
					{
						requestAnimationFrame(update);
					}
					else
					{
						element.innerText = currentValue.toFixed(2).replace('.',',');
						return
					}
				}
			
				requestAnimationFrame(update);
			}
		},

	//	Generar interpolación entre el valor actual y final
		totales_actualizacion_votos_totales : (element, newValue, duration) =>
		{
		//	Obtener del DOM el valor actual
			const startValue = Number(element.innerText.replace('.',''));
			const newValueFormated = Number(newValue);
		
		//	Validar cambio en los votos
			if( startValue === newValueFormated )
			{
				return
			}
			else
			{
				const increment = newValue - startValue;
				const startTime = performance.now();
			
				function update(currentTime)
				{
					const elapsedTime = currentTime - startTime;
					const progress = Math.min(elapsedTime / duration, 1);
					const currentValue = startValue + increment * progress;

					element.innerText = App.numero(currentValue.toFixed(0))
					
					if (progress < 1)
					{
						requestAnimationFrame(update);
					}
					else
					{
						element.innerText = App.numero(currentValue.toFixed(0))
						return
					}
				}
			
				requestAnimationFrame(update);
			}
		},

	//	-			-			-			-			-			-			-			-			-			-			-			-			

	//	Mesa con resultados totales
		totales : async function( tipo , zona )
		{
			mesa_totales_tipo = tipo
			mesa_totales_zona = zona

		//	Solicitar la mesa asignada
			const api = await fetch( path_app + '/swich/consolidados-presidencial/' )
			.then( res => res.json() )
			.then( res => res || [] );

			mesa_totales_mesas = api.mesas
			mesa_totales_votos = api.votos

		//	Almacenar listado de candidatos para gestionar actualizacion
			mesa_totales_candidatos = api.candidatos

		//	Validar que existan mesas en la Zona
			if( api.mesas > 0 )
			{
			//	Dibujar la mesa en el DOM
				App.totales_draw();

			//	Actualizar estado
				mesa_totales_estado = true
			}
		},

	//	Actualizar Mesa con resultados totales
		totales_actualizar : async function()
		{
		//	Solicitar la mesa asignada
			const api = await fetch( path_app + '/swich/consolidados-presidencial/' )
			.then( res => res.json() )
			.then( res => res || [] );

			mesa_totales_mesas = api.mesas
			mesa_totales_votos = api.votos

		//	Almacenar listado de candidatos para gestionar actualizacion
			mesa_totales_candidatos = api.candidatos

			const get_mesa_totales_votos = document.getElementById('mesa-0-totales');
			App.totales_actualizacion_votos_totales(get_mesa_totales_votos , mesa_totales_votos , 1000 );

		//	Validar que existan mesas en la Zona
			if( api.mesas > 0 )
			{
				if( mesa_totales_estado )
				{
					App.ordenar_votos_totales();
				}
			}

		//	Reloj
			App.actualizar_reloj();
		},

	//	Actualizar reloj de consolidados
		actualizar_reloj : function()
		{
		/*
		//	Construir reloj
			const now = new Date();
			const hh = String(now.getHours()).padStart(2, '0');
			const mm = String(now.getMinutes()).padStart(2, '0');
			const reloj = `${hh}:${mm}`;

			const contenedor_reloj = document.getElementById('candidatos-reloj');
			contenedor_reloj.innerHTML = reloj
		*/
		},

	//	Ordenar Votos de los candidatos
		ordenar_votos_totales : function ()
		{
		//	Ordenar los candidatos por sus votos
			mesa_totales_candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.orden > b.orden) ? 1 : -1) : -1 )

		//	Orden del candidato
			let id_orden = 1;

		//	Iterar listado de candidatos
			mesa_totales_candidatos.forEach(candidato =>
			{
			//  Get object from DOM
				const candidato_div = document.getElementById(`candidato-${candidato.id}`);
				candidato_div.classList = `candidato order-${id_orden}`;

			//	Obtener valor del voto
				const candidato_voto_valor = document.getElementById(`candidato-${candidato.id}-votos`);

			//	Animar votos
				App.totales_actualizacion_votos(candidato_voto_valor , candidato.porcentaje , 1000 );

			//	Validar Posicion de los Objetos
				if( mesa_totales_cantidad == 'l')
				{
					if( id_orden < 3 )
					{
						id_orden++	
					}
					else
					{
						id_orden = 4
					}
				}
				else
				{
					id_orden++
				}
			});
		},

	//	Dibujar la mesa en el DOM
		totales_draw : function()
		{
		//  DIV render en el DOM
			const render = document.getElementById('render-mesa-totales' );

		//	Vaciar el contenedor
			render.innerHTML = '';

		//	Crear el DIV de la mesa
			const div_mesa = document.createElement('div');
			div_mesa.id = 'mesa-0'

		//	Asignar las clases a la mesa
			div_mesa.className = `consolidados`

			let template_candidatos = ''

			if( mesa_totales_cantidad == 'l' )
			{
				template_candidatos = 'tres'
			}
			else
			{
				template_candidatos = 'ocho'
			}

		//	Crear elementos en el DIV
			div_mesa.innerHTML =   `<div class="candidatos ${template_candidatos}" id="mesa-0-candidatos"></div>
									<div class="candidatos-detalles">
										<div class="candidatos-detalles-votos">
											<span class="candidatos-detalles-votos-border"></span>
											<span class="candidatos-detalles-votos-titulo">
												CONSOLIDADO
											</span>
											<span class="candidatos-detalles-votos-chv">
												CHV
											</span>
											<span class="candidatos-detalles-votos-totales" id="mesa-0-totales">
												${ App.numero(mesa_totales_votos) }
											</span>
											<span class="candidatos-detalles-votos-subtitulo">
												VOTOS
											</span>
										</div>
									</div>`;
/*
									<div class="candidatos-detalles-hashtag">#Elecciones2025</div>
									<div class="candidatos-detalles-reloj" id="candidatos-reloj">16:22</div>
									<div class="candidatos-detalles-logo">
										<img src="${path_imagenes}logo-chv-noticias.png?v=2.5" />
									</div>
*/

		//	Dibujar la Mesa en el DOM
			render.appendChild(div_mesa);

		//	Render de los candidatos en la mesa
			const render_candidatos = document.getElementById('mesa-0-candidatos');

		//	Indice del orden
			let id_orden = 1;

		//	Ordenar Candidatos por sus votos
			mesa_totales_candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.orden > b.orden) ? 1 : -1) : -1 )

		//	Recorrer el listado de candidatos
			mesa_totales_candidatos.forEach(candidato =>
			{
			//	Crear el div contenedor del candidato
				const objeto = document.createElement('div');
				objeto.className = `candidato order-${id_orden}`

			//	Asignar las propiedades del div
				objeto.id = 'candidato-' + candidato.id

			//	Asignar los elementos al div
				objeto.innerHTML = `<div class="candidato-electo">
										<img src="${path_imagenes}icono-electo.png" />
									</div>
									<div class="candidato-imagen">
										<div class="candidato-imagen-cnt">
											<img class="candidato-imagen-src" src="${path_imagenes_candidatos}${candidato.id}.webp?v=2.5" />
										</div>
									</div>
									<div class="candidato-detalles">
										<img src="${path_imagenes}bg-candidato-consolidados${ template_candidatos =='tres' ? '' : '-ocho'}.png?v=2.5" />
										<div class="candidato-detalles-nombre">${candidato.nombres} ${candidato.apellidos}</div>
										<div class="candidato-votos-valor">
											<span class="votos" id="candidato-${candidato.id}-votos">${ candidato.porcentaje.replace('.',',') }</span>
											<span class="porcentaje">%</span>
										</div>
									</div>
									<div class="candidato-votos-animacion"></div>
									<div class="candidato-fondo">
										<img src="${path_imagenes}bg-candidato-consolidados${ template_candidatos =='tres' ? '' : '-ocho'}.png?v=2.5" />
									</div>`

			//	Crear candidato en el listado
				render_candidatos.appendChild(objeto);

			//	Validar Posicion de los Objetos
				if( mesa_totales_cantidad == 'l')
				{
					if( id_orden < 3 )
					{
						id_orden++	
					}
					else
					{
						id_orden = 4
					}
				}
				else
				{
					id_orden++
				}
			});

		//	Mostrar el pantalla
			App.animar_entrada_totales();
		},

	//	Animar la entrada del bloque
		animar_entrada_totales : function()	
		{
		//	Asignar Posiciones en el eje X
			render_mesa_totales.style.top = mesa_totales_cordenadas.template_floating.visible.y;
			render_mesa_totales.style.left = mesa_totales_cordenadas.template_floating.visible.x;

		//	Iniciar el intervalo de actualización
			App.totales_actualizacion_iniciar();
			
		//	Set estado del total
			mesa_totales_estado = true;
		},

	//	Animar la entrada del bloque
		animar_salida_totales : function()
		{
		//	Asignar Posiciones en el eje X
			render_mesa_totales.style.top = mesa_totales_cordenadas.template_floating.oculta.y;
			render_mesa_totales.style.left = mesa_totales_cordenadas.template_floating.oculta.x;

		//	Definir estado de totales
			mesa_totales_estado = false;
		},

	//	-			-			-			-			-			-			-			-			-			-			-			-			

	//	Crear diccionarios
		zone : async function()
		{
		//	Solicitar la mesa asignada
			const api = await fetch( path_app_zonas )
			.then( res => res.json() )
			.then( res => res || [] );

		//	Generar diccionario
			objeto_regiones = api.regiones
			objeto_provincias = api.provincias
			objeto_comunas = api.comunas
			objeto_circunscripciones = api.circunscripciones
			objeto_distritos = api.distritos
			objeto_pactos = api.pactos
			objeto_partidos = api.partidos
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
        //  DIV render en el DOM
            const render	=	document.getElementById('render-mesa-' + posicion );

			let mesa_tipo;
			let mesa_titulo;
			let mesa_zona;

		//	Validar tipo de mesa
			if( mesa.tipo == 'P' )
			{
				mesa_tipo = 'PRESIDENCIAL'
				mesa_zona = mesa.comuna
			}
			else if( mesa.tipo == 'S' )
			{
				mesa_tipo = 'SENADORES'
				mesa_titulo = ''
				mesa_zona = App.obtener_region(Number(mesa.zona_id))
			}
			else if( mesa.tipo == 'D' )
			{
				mesa_tipo = 'DIPUTADOS'

				const zona = App.consultar_distrito(mesa.zona_id)
				mesa_titulo = 'D-' + zona.orden
				mesa_zona = mesa.comuna
			}
			else
			{

			}

		//	Vaciar el contenedor
			render.innerHTML = '';

		//	Crear el DIV de la mesa
			const div_mesa = document.createElement('div');
			div_mesa.id = 'mesa-' + mesa.id

		//	Asignar las clases a la mesa
			div_mesa.className = `box tipo-${mesa_tipo.toLowerCase()} pos-${posicion}`

		//	Crear elementos en el DIV
			div_mesa.innerHTML =   `<div class="header">
										<div class="header-contenedor">
											${
												mesa.tipo == 'P' ?
												`<h1>${mesa_tipo}</h1>`
												:
												`<h1>${mesa_tipo} <span>${mesa_titulo}</span></h1>`
											}
											<h3>
												${mesa.local}
											</h3>
											<h2>
												<span>${mesa.numero}</span>
												${mesa_zona}
												<div class="separador"></div>
											</h2>
										</div>
									</div>
									<div class="candidatos-padding">
										<div class="candidatos" id="mesa-${mesa.id}-candidatos"></div>
									</div>`;

        //	Dibujar la Mesa en el DOM
			render.appendChild(div_mesa);

		//	Render de los candidatos en la mesa
			const render_candidatos = document.getElementById('mesa-' + mesa.id + '-candidatos');

		//	Indice del orden
			let id_orden = 1;

		//	Ordenar los candidatos por sus votos
			mesa.candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.orden > b.orden) ? 1 : -1) : -1 )

        //	Recorrer el listado de candidatos
			mesa.candidatos.forEach(candidato =>
            {
            //	Crear el div contenedor del candidato
                const objeto = document.createElement('div');
				objeto.className = `candidato order-${id_orden}`

            //	Asignar las propiedades del div
                objeto.id = 'candidato-' + candidato.objeto

			//	Asignar los elementos al div
				objeto.innerHTML = `<div class="candidato-imagen">
										<img
											src="${path_imagenes_candidatos}${candidato.id}.webp"
											id="candidato-imagen-${mesa.id}-${candidato.id}"
											class="candidato-imagen-src"
											data-nombre="${candidato.nombres} ${candidato.apellidos}"
											data-objeto="${candidato.id}"
											data-load="false"
										/>
									</div>
									<div class="candidato-info">
										<div class="candidato-detalles">
											<div class="candidato-detalles-apellido">
												${
													mesa.tipo == 'P' ?
													candidato.apellidos
													:
													App.construir_nombre(candidato)
												}
											</div>
											<div class="candidato-detalles-partido">
												${ candidato.partido }
											</div>
										</div>
										<div class="candidato-votos">
											<div id="candidato-${candidato.objeto}-votos" class="candidato-votos-valor">
												${candidato.votos}
											</div>
										</div>
										<div id="candidato-${candidato.objeto}-animacion" class="candidato-votos-animacion"></div>
									</div>`

            //	Crear candidato en el listado
				render_candidatos.appendChild(objeto);

			//	Validar Posicion de los Objetos
				if( id_orden < cantidad_maxima_candidatos )
				{
					id_orden++;
				}
				else
				{
					id_orden = cantidad_maxima_candidatos + 1;
				}
            });

		//	Ordenar Votos de los candidatos
		//	App.ordenar_votos(mesa.candidatos);

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

		//	Validar imagenes de los candidatos
			candidato_poster( mesa.id );
		},

	//	Asignar votos a un candidato
		voto : function( id , mesa, candidato, votos )
		{
		//	Buscar en candidato en el DOM
			const candidato_votos = document.getElementById(`candidato-${id}-votos`);

		//	Validar que exista el elemento
			if( candidato_votos == null )
			{
				return
			}
			else
			{
			//	Actualizar los votos
			//	candidato_votos.innerHTML = votos + '<img src="" class="candidato-votos-valor-icono" />';
				candidato_votos.innerHTML = votos;

			//	Obtener el contenedor de la animación
				const candidato_animacion = document.getElementById(`candidato-${id}-animacion`);
				candidato_animacion.classList.add('animar_voto');

				if( mesa_1 )
				{
					if( mesa == mesa_1.id)
					{
					//	Actualizar la cantidad de votos
						const result = mesa_1.candidatos.find(({ objeto }) => objeto === id);
						result.votos = votos;

					//	Actualizar DOM
						App.ordenar_votos(mesa_1.candidatos);
					}
				}

				if( mesa_2 )
				{
					if( mesa == mesa_2.id)
					{
					//	Actualizar la cantidad de votos
						const result = mesa_2.candidatos.find(({ objeto }) => objeto === id);
						result.votos = votos;

					//	Actualizar DOM
						App.ordenar_votos(mesa_2.candidatos);
					}
				}

			//	Esperar que la animación termine
				candidato_animacion.addEventListener('animationend' , function()
				{
				//	Eliminar la animación
					candidato_animacion.classList.remove('animar_voto');
				});
			}
		},

	//	Ordenar Votos de los candidatos
		ordenar_votos : function (candidatos)
		{
		//	Orden del candidato
			let id_orden = 1;

		//	Ordenar los votos de la mesa
			candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.orden > b.orden) ? 1 : -1) : -1 )

		//	Iterar listado de candidatos
			candidatos.forEach(candidato =>
			{
			//  Get object from DOM
				const candidato_div = document.getElementById(`candidato-${candidato.objeto}`);
				candidato_div.classList = `candidato order-${id_orden}`;

			//	Validar Posicion de los Objetos
				if( id_orden < cantidad_maxima_candidatos )
				{
					id_orden++;
				}
				else
				{
					id_orden = cantidad_maxima_candidatos + 1;
				}
			});
		},

	//			-			-			-			-			-			-			-			-			-			-			-

	//	Animar la entrada del bloque
		animar_entrada_mesa_1 : function()
		{
			render_mesa_1.classList.add('transition-on')

		//	Asignar Posiciones en el eje X
			render_mesa_1.style.bottom = mesa_1_cordenadas.template_tottem.visible.y;
			render_mesa_1.style.left = mesa_1_cordenadas.template_tottem.visible.x;
			render_mesa_1.style.transform = mesa_1_cordenadas.template_tottem.visible.z;
		},

	//	Animar la entrada del bloque
		animar_entrada_mesa_2 : function()
		{
			setTimeout(function()
			{
				render_mesa_2.classList.add('transition-on')

			//	Asignar Posiciones en el eje X
				render_mesa_2.style.bottom = mesa_2_cordenadas.template_tottem.visible.y;
				render_mesa_2.style.left = mesa_2_cordenadas.template_tottem.visible.x;
				render_mesa_2.style.transform = mesa_2_cordenadas.template_tottem.visible.z;

			}, 200 );
		},

	//			-			-			-			-			-			-			-			-			-			-			-

	//	Animar la entrada del bloque
		animar_salida_mesa_1 : function( template , modo , mesa_id )
		{
		//	Asignar Posiciones en el eje X
			render_mesa_1.style.bottom = mesa_1_cordenadas.template_tottem.oculta.y;
			render_mesa_1.style.left = mesa_1_cordenadas.template_tottem.oculta.x;
			render_mesa_1.style.transform = mesa_1_cordenadas.template_tottem.oculta.z;

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

				}, tiempo_transiciones );
			}
			else
			{
			//	Limpiar mesa
				setTimeout(function()
				{
					if( switch_mesa_1 == null )
					{
					//	Limpiar el Objeto
						mesa_1 = null

					//	Limpiar el DOM
						render_mesa_1.innerHTML = ''
					}

				}, tiempo_transiciones );
			}

			mesa_1_historico = 0
		},

	//	Animar la entrada del bloque
		animar_salida_mesa_2 : function( template , modo , mesa_id )
		{
		//	Asignar Posiciones en el eje X
			render_mesa_2.style.bottom = mesa_2_cordenadas.template_tottem.oculta.y;
			render_mesa_2.style.left = mesa_2_cordenadas.template_tottem.oculta.x;
			render_mesa_2.style.transform = mesa_2_cordenadas.template_tottem.oculta.z;

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

				}, tiempo_transiciones );
			}
			else
			{
			//	Limpiar mesa
				setTimeout(function()
				{
					if( switch_mesa_2 == null )
					{
					//	Limpiar el Objeto
						mesa_2 = null

					//	Limpiar el DOM
						render_mesa_2.innerHTML = ''
					}

				}, tiempo_transiciones );
			}

		//	if( mesa_totales_estado != true && mesa_id == null )
			if( mesa_id == null )
			{
				mesa_2_historico = 0
			}
		},

	//			-			-			-			-			-			-			-			-			-			-			-

	//	Construir el nombre del candidato
		construir_nombre : function ( candidato )
		{
			const nombre = candidato.nombres.trim().charAt(0);
			const apellido = candidato.apellidos.trim().split(' ');
			return `${nombre}.&nbsp;&nbsp;${apellido[0]}`;
		},

	//	Obtener información del Partido
		consultar_region : function ( id )
		{
			const region = objeto_regiones.find( obj => obj.id === Number(id) );
			return region;
		},

	//	Obtener información de la circunscripcion
		consultar_circunscripcion : function ( id )
		{
			const circunscripcion = objeto_circunscripciones.find( obj => obj.id === Number(id) );
			return circunscripcion;
		},

	//	Obtener información del distrito
		consultar_distrito : function ( id )
		{
			const distrito = objeto_distritos.find( obj => obj.id === Number(id) );
			return distrito;
		},

	//			-			-			-			-			-			-			-			-			-			-			-

	//	Obtener información del Partido
		obtener_region : function ( id )
		{
			const circunscripcion = objeto_circunscripciones.find( obj => obj.id === id );
			const region = objeto_regiones.find( obj => obj.id === circunscripcion.region );
			return region.nombre
		},

	//	Obtener información del Partido
		obtener_partido : function ( id )
		{
			const partido = objeto_partidos.find( obj => obj.id === id );
			return partido.sigla;
		},

	//	Obtener información del Pacto
		obtener_pacto : function ( id )
		{
			const pacto = objeto_pactos.find( obj => obj.id === id );
			return pacto.letra;
		},

	//	Agregar miles a los numeros
		numero : function( valor )
		{
			return new Intl.NumberFormat('en-DE').format(valor);
		}

	}

//	Validación de las Imagenes
	const candidato_poster = async ( id ) =>
	{
		//	Actualizar votos en el DOM
		const candidato_voto = document.getElementById(`mesa-${id}-candidatos`);

	//	Recorrer las imagenes de los candidatos
		Array.from(candidato_voto.querySelectorAll('.candidato-imagen-src')).forEach(function(e)
		{
			candidato_poster_crear( id , e.dataset.objeto );
		});
	}

//	Validar la imagen del Candidato
	const candidato_poster_crear = async ( mesa , id ) =>
	{
	//	Obtener información del objeto
		const objeto = document.getElementById('candidato-imagen-' + mesa + '-' + id);

	//	Version de cache de las imagenes
		const version = '1.1.3';

	//	Construir ruta de la imagen
		const objeto_imagen = path_imagenes_candidatos + objeto.dataset.objeto + '.webp?v=' + version;

	//	Solicitar la imagen
		await fetch( objeto_imagen , { method: 'GET' }).then(res =>
		{
			if ( res.ok )
			{
				objeto.src = objeto_imagen;
				objeto.style.opacity = 1
				objeto.dataset.load = true
			}
			else
			{
				objeto.src = path_imagenes_candidatos_error
				objeto.style.opacity = 1
				objeto.dataset.load = false

				console.log( '[404]' , objeto.dataset.objeto , '-' , objeto.dataset.nombre );
			}
		});
	}

//	Iniciar las Zonas
	App.zone();