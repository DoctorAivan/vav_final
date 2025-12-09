    //	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-
    //	FUNCIONALIDAD PUBNUB PARA MOVILES
    //	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

    //  Asignar el nombre del dispositivo
    const pubnub_user = "mobile_monitor";

    //  Notificación de Audio
    var audio = new Audio(path_app + '/app.librerias/audio/notificacion.ogg');

    //	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

    //	Iniciar Funcionalidad
    pubnubMovil.addListener(
    {
        message: async function (message) {

            //	Obtener Datos desde Pubnub
            const datoPubNub = message.message;

            //  Obtener accion solicitada
            const accion = datoPubNub.accion;

            // Crear nueva mesa
            if (accion == 'mesa_crear') {

                // Enviar solicitud al backend
                $.post(path_app + '/movil/mesas/nueva/',
                {
                    mesa_tipo: datoPubNub.mesa.tipo,
                    mesa_zona: datoPubNub.mesa.zona,
                    mesa_comuna: datoPubNub.mesa.comuna,
                    mesa_local: datoPubNub.mesa.local,
                    mesa_numero: datoPubNub.mesa.numero
                })
                .done( function (data) {

                    pubnub_message_mobile(
                        pubnub_user,
                        message.publisher,
                        {
                            type : 'mesa_nueva',
                            data : data
                        }
                    );

                });
            }

            // Editar una mesa
            else if (accion == 'mesa_editar') {

                // Enviar solicitud al backend
                $.post(path_app + '/mesas/guardar/',
                {
                    usuario_id: 53,
                    mesa_id: datoPubNub.mesa.id,
                    mesa_estado: datoPubNub.mesa.estado,
                    mesa_comuna: datoPubNub.mesa.comuna,
                    mesa_local: datoPubNub.mesa.local,
                    mesa_numero: datoPubNub.mesa.numero
                })
                .done( function (data) {

                    console.log(data);

                });
            }

            //  Activar una mesa
            else if (accion == 'mesa_estado') {
                
                //	Actualizar los votos de la Mesa
                $.post(path_app + '/mesas/cambiar-estado/',
                {
                    mesa_id: datoPubNub.mesa.id,
                    mesa_estado: datoPubNub.mesa.estado
                })
                .done(function (response) {
                    
                    //  Validar Respuesta de la DB
                    if (response == 1) {

                        //	Enviar Notificación a PubNub
                        pubnub_message({
                            'accion': 'recargar'
                        });

                        //  -       -       -       -       -       -       -       -

                        let debug_accion;
                        let debug_color;

                        if(datoPubNub.mesa.estado == 1 )
                        {
                            debug_accion = 'Mesa Publicada';
                            debug_color = 'verde';
                        }
                        else
                        {
                            debug_accion = 'Mesa Cerrada';
                            debug_color = 'naranja';
                        }

                        //  Crear Objeto Debug
                        let objDebug = {
                            'metodo': 'POST',
                            'icono': 'fas fa-info-circle',
                            'accion': debug_accion,
                            'color': debug_color,
                            'comuna': datoPubNub.mesa.comuna,
                            'local': datoPubNub.mesa.local,
                            'numero': datoPubNub.mesa.numero,
                            'msg': 'Mesa publicada',
                            'usuario': message.publisher
                        }

                        //  Debug
                        debug(objDebug);

                    }
                });
            }

            //  Eliminar una mesa
            else if (accion == 'mesa_eliminar') {
                
                //	Actualizar los votos de la Mesa
                $.post(path_app + '/mesas/eliminar/',
                {
                    mesa_id: datoPubNub.mesa.id
                })
                .done(function (response) {
                
                    //	Enviar Notificación a PubNub
                    pubnub_message({
                        'accion': 'recargar'
                    });

                    //  -       -       -       -       -       -       -       -

                    //  Crear Objeto Debug
                    let objDebug = {
                        'metodo': 'POST',
                        'icono': 'fas fa-info-circle',
                        'accion': 'Mesa Eliminada',
                        'color': 'rojo',
                        'comuna': datoPubNub.mesa.comuna,
                        'local': datoPubNub.mesa.local,
                        'numero': datoPubNub.mesa.numero,
                        'usuario': message.publisher
                    }

                    //  Debug
                    debug(objDebug);
                });
            }

            //  Recibir votos de una mesa
            else if (accion == 'mesa_voto') {
                
                //  Obtener ID del usuario
                let mesa_id = datoPubNub.mesa.id;
                let voto_id = datoPubNub.mesa.candidato;
                let voto_total = datoPubNub.mesa.voto;

                //	Actualizar los votos de la Mesa
                $.post(path_app + '/mesas/voto/',
                {
                    mesa_id: mesa_id,
                    voto_id: voto_id,
                    voto_total: voto_total
                })
                .done(function (response) {

                    //	Construir Variable para enviar a PubNub
                    let pubnub =
                    {
                        'accion': 'voto',
                        'accion_voto' : 'S',
                        'mesa': mesa_id,
                        'id': voto_id,
                        'valor': voto_total,
                        'candidato' : 0
                    }

                    //	Enviar Notificación a PubNub
                    pubnub_message(pubnub);

                });
            }

        }
    });

    //	Suscribirse al Canal
    pubnubMovil.subscribe({
        channels: ['vav_movil.' + pubnub_user],
        withPresence: false
    });

    //	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

    // Enviar mensaje transmisión
    const pubnub_message = (message) => {

        // Enviar respuesta global
        pubnub.publish({
            channel: "vav_mesas",
            message: message
        });

    }

    // Enviar mensaje moviles
    const pubnub_message_mobile = (from , to , message) => {

        // Enviar respuesta al movvil
        pubnubMovil.publish({
            channel: "vav_movil." + to,
            message: message
        });

    }

    //	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

    //  Debugear Estados
    function debug(obj) {

        //  Crear objeto con la Fecha y Hora
        var date = new Date();

        //  Construir objeto 
        var dateStr = ("00" + (date.getMonth() + 1)).slice(-2) + "/" + ("00" + date.getDate()).slice(-2) + "/" + date.getFullYear() + " " + ("00" + date.getHours()).slice(-2) + ":" + ("00" + date.getMinutes()).slice(-2) + ":" + ("00" + date.getSeconds()).slice(-2);

        //  Crear Div
        let div =   `<div class="box monitor nuevo-dato">
                        <div class="usuario"><i class="fas fa-mobile-alt"></i> ${obj.usuario}</div>
                        <div class="bold ${obj.color}"><i class="fas ${obj.icono}"></i> ${obj.accion}</div>
                        <div class="comuna"><i class="fas fa-globe-americas"></i> ${obj.comuna}</div>
                        <div class="local"><i class="fas fa-map-marker"></i> ${obj.local}</div>
                        <div class="mesa"><i class="fas fa-hashtag"></i> MESA ${obj.numero}</div>
                        <div class="hora"><i class="fas fa-clock"></i> ${dateStr}</div>
                    </div>`;

        //  Agregar Div a la Inteface
        $("#debug").prepend(div);

        //  Quitar mensaje de vacio
        $("#debug").find('.debug_vavio').remove();

        //  Reproducir Sonido
        audio.pause();
        audio.currentTime = 0;
        audio.play();
    }

    //  Borrar Historial
    function borrarHistorial() {
        
        $("#debug").html('');

        //  Crear Div
        let div = `<div class="box debug_vavio">
                Aun no existen notificaciones
            </div>`;

        //  Agregar Div a la Inteface
        $("#debug").prepend(div);
    }