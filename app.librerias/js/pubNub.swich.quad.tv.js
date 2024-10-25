//	URL del diccionario de zonas
	const path_app_zonas = path_app + '/app.librerias/zonas.json?v=1.5'

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
	let mesa_1_historico = 0
	let mesa_1_switch = 0

	let mesa_2 = null
	let mesa_2_historico = 0
	let mesa_2_switch = 0

	let mesa_3 = null
	let mesa_3_historico = 0
	let mesa_3_switch = 0

	let mesa_4 = null
	let mesa_4_historico = 0
	let mesa_4_switch = 0

//	Transiciones
	let tiempo_transiciones = 750
	let tiempo_transiciones_adicional = 1000

//	-			-			-			-			-			-			-			-			-			-			-			-			

//	URL del repositorio de las imagenes
	const path_imagenes = path_app + '/app.imagenes/'
	const path_imagenes_candidatos = path_imagenes + 'candidatos/'
	const path_imagenes_candidatos_error = path_imagenes + 'candidatos/000.png'

//	-			-			-			-			-			-			-			-			-			-			-			-			

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
			if( accion == 'switchQuad' )
			{
			//	Asignar los ID de las Mesas enviadas
				mesa_1_switch = datoPubNub.mesa_1
				mesa_2_switch = datoPubNub.mesa_2
				mesa_3_switch = datoPubNub.mesa_3
				mesa_4_switch = datoPubNub.mesa_4
				app_template = datoPubNub.template

			//	Iniciar Animaciones
				App.init();
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

			//	Validar que el voto emitido este en pantalla
				App.voto( id , mesa , candidato , voto );
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
			const api = await fetch( path_app + '/swich-quad/mesas-actuales/' )
			.then( res => res.json() )
			.then( res => res.mesas || [] );

			if( mesa_1_switch != null && app_template >= 1 )
			{
				mesa_1 = api[mesa_1_switch];
				if( mesa_1.id != mesa_1_historico)
				{
					App.in( 1 , mesa_1 );
				}
				else
				{
					App.return(1)
				}
			}
			else
			{
				App.out(1)
			}

			if( mesa_2_switch != null && app_template >= 2 )
			{
				mesa_2 = api[mesa_2_switch];
				if( mesa_2.id != mesa_2_historico)
				{
					App.in( 2 , mesa_2 );
				}
				else
				{
					App.return(2)
				}
			}
			else
			{
				App.out(2)
			}

			if( mesa_3_switch != null && app_template >= 3 )
			{
				mesa_3 = api[mesa_3_switch];
				if( mesa_3.id != mesa_3_historico)
				{
					App.in( 3 , mesa_3 );
				}
				else
				{
					App.return(3)
				}
			}
			else
			{
				App.out(3)
			}

			if( mesa_4_switch != null && app_template >= 4 )
			{
				mesa_4 = api[mesa_4_switch];
				if( mesa_4.id != mesa_4_historico)
				{
					App.in( 4 , mesa_4 );
				}
				else
				{
					App.return(4)
				}
			}
			else
			{
				App.out(4)
			}
		},

	//	View IN
		in : function( id , mesa )
		{
			const render	=	document.getElementById('view-' + id );
			render.classList.add('anim_view_out')

		//	Reiniciar animación del voto
			setTimeout(function()
			{
				App.draw( id , mesa );
			}, tiempo_transiciones );			
		},

	//	View OUT
		out : function( id )
		{
			const render	=	document.getElementById('view-' + id );
			render.classList.add('anim_view_out')

		//	Reiniciar animación del voto
			setTimeout(function()
			{
				render.innerHTML = '';
			}, tiempo_transiciones );			

		//	Vaciar Mesa Historico
			App.resetear_mesa_historico( id );
		},

	//	View RETURN
		return : function( id )
		{
			const render	=	document.getElementById('view-' + id );
			render.classList.remove('anim_view_out')
			render.classList.add('anim_view_in')
		},

	//	Quitar Historico
		resetear_mesa_historico : function( id )
		{
			if( id == 1 ){ mesa_1_historico = 0 }
			if( id == 2 ){ mesa_2_historico = 0 }
			if( id == 3 ){ mesa_3_historico = 0 }
			if( id == 4 ){ mesa_4_historico = 0 }
		},

	//	Dibujar la mesa en el DOM
		draw : function( id , mesa )
		{
		//	Obtener contenedor de la mesa
			const render	=	document.getElementById('view-' + id );
			render.innerHTML = '';

		//	Crear el DIV de la mesa
			let div_mesa = document.createElement('div');
			div_mesa.id = 'mesa-' + mesa.id

		//	Crear elementos en el DIV
			div_mesa.innerHTML =   `<div class="header">
										<h2>${mesa.comuna}</h2>
										<h3>${mesa.local}</h3>
									</div>
									<div class="candidatos" id="mesa-${mesa.id}-candidatos"></div>`;

        //	Dibujar la Mesa en el DOM
			render.appendChild(div_mesa);

			render.classList.remove('anim_view_out')
			render.classList.add('anim_view_in')

		//	-		-		-		-		-		-		-		-		-		-		-		-		-

		//	Render de los candidatos en la mesa
			const render_candidatos = document.getElementById('mesa-' + mesa.id + '-candidatos');

		//	Indice del orden
			let id_orden = 1;

		//	Ordenar los candidatos por sus votos
			mesa.candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.apellidos > b.apellidos) ? 1 : -1) : -1 )

		//	Recorrer el listado de candidatos
			mesa.candidatos.forEach(candidato =>
			{
			//	Crear el div contenedor del candidato
				let objeto = document.createElement('div');
				objeto.className = `candidato order-${id_orden}`

			//	Asignar las propiedades del div
				objeto.id = 'candidato-' + candidato.objeto

			//	Asignar los elementos al div	
				objeto.innerHTML = `<div class="candidato-imagen">
										<div class="candidato-imagen-marco">
											<img
												src=""
												id="candidato-imagen-${mesa.id}-${candidato.id}"
												class="candidato-imagen-src"
												data-nombre="${candidato.nombres} ${candidato.apellidos}"
												data-objeto="${candidato.id}"
												data-load="false"
											/>
										</div>
									</div>
									<div class="candidato-ficha">
										<div class="candidato-ficha-nombre">${candidato.nombres}</div>	
										<div class="candidato-ficha-apellido">${candidato.apellidos}</div>
										<div class="candidato-ficha-footer">
											<div class="candidato-ficha-footer-pacto">
												<div class="partido">${App.obtener_partido(candidato.partido_id)}</div>
												<div class="pacto">${App.obtener_pacto(candidato.pacto_id)}</div>
											</div>
											<div class="candidato-ficha-footer-votos" id="candidato-${candidato.objeto}-votos">
												${candidato.votos}
											</div>
										</div>
										<div class="candidato-votos-animacion"></div>
									</div>`

			//	Crear candidato en el listado
				render_candidatos.appendChild(objeto);

			//	Validar Posicion de los Objetos
				if( id_orden < 2 )
				{
					id_orden++	
				}
				else
				{
					id_orden = 3
				}
			});

		//	Asignar historico
			if( id == 1 ){ mesa_1_historico = mesa.id }
			if( id == 2 ){ mesa_2_historico = mesa.id }
			if( id == 3 ){ mesa_3_historico = mesa.id }
			if( id == 4 ){ mesa_4_historico = mesa.id }

		//	Validar imagenes de los candidatos
			candidato_poster( mesa.id );
		},

	//	Asignar votos a un candidato
		voto : function( id , mesa, candidato, votos )
		{
		//	Actualizar votos en el DOM
			const candidato_voto = document.getElementById(`candidato-${id}`);			

		//	Validar que exista el elemento
			if( candidato_voto != null )
			{
				const candidato_div_voto_valor = document.querySelector('#candidato-' + id + ' > div.candidato-ficha > div.candidato-ficha-footer > div.candidato-ficha-footer-votos');
				candidato_div_voto_valor.innerHTML = votos;

				const candidato_div_voto_animacion = document.querySelector('#candidato-' + id + ' > div.candidato-ficha > div.candidato-votos-animacion');
				candidato_div_voto_animacion.classList.add('animar_voto');

			//	Reiniciar animación del voto
				setTimeout(function()
				{
					candidato_div_voto_animacion.classList.remove('animar_voto');
					
				}, tiempo_transiciones_adicional);

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

				if( mesa_3 )
				{
					if( mesa == mesa_3.id)
					{
						const result = mesa_3.candidatos.find(({ objeto }) => objeto === id);
						result.votos = votos;
						App.ordenar_votos(mesa);
					}
				}

				if( mesa_4 )
				{
					if( mesa == mesa_4.id)
					{
						const result = mesa_4.candidatos.find(({ objeto }) => objeto === id);
						result.votos = votos;
						App.ordenar_votos(mesa);
					}
				}

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
					mesa_1.candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.apellidos > b.apellidos) ? 1 : -1) : -1 )

				//	Guardar Mesa
					mesa_candidatos = mesa_1.candidatos;
				}
			}

		//	Validar si existe mesa 2
			if( mesa_2 )
			{
				if( mesa == mesa_2.id )
				{
				//	Ordenar los candidatos por sus votos
					mesa_2.candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.apellidos > b.apellidos) ? 1 : -1) : -1 )

				//	Guardar Mesa
					mesa_candidatos = mesa_2.candidatos;
				}
			}

		//	Validar si existe mesa 3
			if( mesa_3 )
			{
				if( mesa == mesa_3.id )
				{
				//	Ordenar los candidatos por sus votos
					mesa_3.candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.apellidos > b.apellidos) ? 1 : -1) : -1 )

				//	Guardar Mesa
					mesa_candidatos = mesa_3.candidatos;
				}
			}

		//	Validar si existe mesa 4
			if( mesa_4 )
			{
				if( mesa == mesa_4.id )
				{
				//	Ordenar los candidatos por sus votos
					mesa_4.candidatos.sort((a, b) => (b.votos > a.votos) ? 1 : (b.votos === a.votos) ? ((a.apellidos > b.apellidos) ? 1 : -1) : -1 )

				//	Guardar Mesa
					mesa_candidatos = mesa_4.candidatos;
				}
			}

		//	Orden del candidato
			let id_orden = 1;

		//	Iterar listado de candidatos
			mesa_candidatos.forEach(candidato =>
			{
			//  Get object from DOM
				let candidato_div = document.getElementById(`candidato-${candidato.objeto}`);
				candidato_div.classList = `candidato order-${id_orden}`;

			//	Validar Posicion de los Objetos
				if( id_orden < 2 )
				{
					id_orden++	
				}
				else
				{
					id_orden = 3
				}
			});
		},

//			-			-			-			-			-			-			-			-			-			-			-

	//	Obtener información del tipo de Mesa
		obtener_tipo_mesa : function ( tipo )
		{
			if( tipo == 'G')
			{
				return 'GOBERNADOR';
			}
			if( tipo == 'A')
			{
				return 'ALCALDE'
			}
		},

	//	Obtener información del Partido
		obtener_partido : function ( id )
		{
			let partido = objeto_partidos.find( obj => obj.id === id );
			return partido.sigla;
		},

	//	Obtener información del Pacto
		obtener_pacto : function ( id )
		{
			let pacto = objeto_pactos.find( obj => obj.id === id );
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
		const objeto_imagen = path_imagenes_candidatos + objeto.dataset.objeto + '.png?v=' + version;

	//	Solicitar la imagen
		await fetch( objeto_imagen , { method: 'GET' }).then(res =>
		{
			if ( res.ok )
			{
				objeto.src = objeto_imagen;
				objeto.style.opacity = 1
			}
			else
			{
				objeto.src = path_imagenes_candidatos_error
				objeto.style.opacity = 1

				console.log( '[404]' , objeto.dataset.objeto , '-' , objeto.dataset.nombre );
			}
		});
	}

//	Iniciar las Zonas
	App.zone();