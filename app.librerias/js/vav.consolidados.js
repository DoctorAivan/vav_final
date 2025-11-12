let consolidado_tipo = ''
let consolidado_zona = 0
let consolidado_zona_nombre = ''

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

// Iniciar al cargar
$(function()
{
    consolidado_tipo = $.cookie('consolidado_tipo')
    consolidado_zona = $.cookie('consolidado_zona')

    //consolidados_render();
});

// Actualizar información del consolidado
function consolidados_render()
{
//  Obtener Elementos del DOM
    const consolidados_render_tipo = document.getElementById('consolidados-render-tipo')
    const consolidados_render_zona = document.getElementById('consolidados-render-zona')

//  Obtener Cookies
    const consolidados_tipo = $.cookie('consolidado_tipo')
    const consolidados_zona_nombre = $.cookie('consolidado_zona_nombre')

//  Validar Tipo
    if( consolidados_tipo == 'P' )
    {
        consolidados_render_tipo.innerHTML = '🔴&nbsp;&nbsp;&nbsp;PRESIDENTES';
    }
    else if( consolidados_tipo == 'S' )
    {
        consolidados_render_tipo.innerHTML = '🔵&nbsp;&nbsp;&nbsp;SENADORES';
    }
    else if( consolidados_tipo == 'D' )
    {
        consolidados_render_tipo.innerHTML = '🟠&nbsp;&nbsp;&nbsp;DIPUTADOS';
    }
    else
    {
        consolidados_render_tipo.innerHTML = '🟢&nbsp;&nbsp;VACIO';
    }

//  Validar Zona Nombre
    if( consolidados_zona_nombre )
    {
        consolidados_render_zona.innerHTML = consolidados_zona_nombre
    }
    else
    {
        consolidados_render_zona.innerHTML = 'ASIGNAR UNA ZONA'
    }
}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

// Consolidados Asignar
function consolidados_asignar()
{
//  Validar el estado del consolidados
    if( estado_consolidados != "on" )
    {
    //  Cambiar la dimensión
        liveboxAncho('consolidados' , 550 );

    //	Abrir Funcionalidad Livebox
        liveboxAbrir('consolidados');

    //  Obtener Tipo
        const consolidados_tipo_cookie = $.cookie('consolidado_tipo')

    //  Marcar Pacto por Defecto
        consolidados_tipo( consolidados_tipo_cookie ? consolidados_tipo_cookie : 'P' );
    //  consolidados_tipo( 'G' );

    //  Limpiar input comunas
        const input_comunas = document.getElementById('mesa_consolidado_comunas')
        input_comunas.value = ''

    //  Funcionalidad Botones nueva mesa
        const mensa_nueva_of = document.getElementById('mesa-nueva-of')
        const mensa_nueva_on = document.getElementById('mesa-nueva-on')

    //  Estado de los botones de accion
        mensa_nueva_of.style.display = 'block';
        mensa_nueva_on.style.display = 'none';
    }
}

// Consolidados Tipo
function consolidados_tipo( tipo )
{
//  Quitar seleccion
    $( '#consolidado-tipo div' ).each(function()
    {
        $( this ).removeClass( 'on' );
    });

//  Destacar Opción
    $( '#consolidado-tipo-' + tipo ).addClass( 'on' );

//  Almacenar tipo de Mesa
    consolidado_tipo       =   tipo;

//  Tipo de mesa
    if( tipo == 'P' )
    {
        consolidados_autocompletar_presidentes();
    }
    else if( tipo == 'S' )
    {
        consolidados_autocompletar_senadores();
    }
    else if( tipo == 'D' )
    {
        consolidados_autocompletar_diputados();
    }
    else
    {
        consolidados_autocompletar_comunas();
    }

    //  Funcionalidad Botones nueva mesa
    const mensa_nueva_of = document.getElementById('mesa-nueva-of')
    const mensa_nueva_on = document.getElementById('mesa-nueva-on')

    //  Estado de los botones
    mensa_nueva_of.style.display = 'block';
    mensa_nueva_on.style.display = 'none';
}

// Consolidados Guardar Valores
function consolidados_guardar()
{
//  Actualizar los valores de las cookies
    $.cookie('consolidado_tipo', consolidado_tipo , { expires: 7, path: '/' });
    $.cookie('consolidado_zona', consolidado_zona , { expires: 7, path: '/' });
    $.cookie('consolidado_zona_nombre', consolidado_zona_nombre , { expires: 7, path: '/' });

//  Actualizar el DOM
    consolidados_render();
    liveboxCerrar();
}

//	-		-		-		-		-		-		-		-		-		-		-		-		-		-		-		-

// Funcionalidad autocompletar
function consolidados_autocompletar_comunas()
{
//  Crear objeto autocompletar
    let options = {
        data: objeto_comunas,
        getValue: "nombre",
        list: {
            maxNumberOfElements: 5,
            match: {
                enabled: true
            }
        },
        template: {
            type: "custom",
            method: function(value, objeto)
            {
            //  Obtener Nombre de la Región
                let region = objeto_regiones.find( obj => obj.id === objeto.region );

            //  Crear div con el resultado
                let div     =   `<div class="box" onClick="consolidados_autocompletar_comunas_asignar(${objeto.id})">
                                    <div class="child">${value}</div>
                                    <div class="parent">${region.nombre}</div>
                                </div>`;

            //  Enviar resultado a la UI
                return div;
            }
        }
    };

//  Asignar funcionalidad
    $("#mesa_consolidado_comunas").easyAutocomplete(options);
}

// Funcionalidad autocompletar asignar
function consolidados_autocompletar_comunas_asignar( id )
{
//  Obtener información de la Comuna
    let comuna = objeto_comunas.find( obj => obj.id === id );

//  Tipo Zona Alcalde
    consolidado_zona = comuna.id;
    consolidado_zona_nombre = comuna.nombre;

//  Funcionalidad Botones nueva mesa
    const mensa_nueva_of = document.getElementById('mesa-nueva-of')
    const mensa_nueva_on = document.getElementById('mesa-nueva-on')

//  Estado de los botones
    mensa_nueva_of.style.display = 'none';
    mensa_nueva_on.style.display = 'block';
}

// Funcionalidad autocompletar
function consolidados_autocompletar_presidentes()
{
//  Crear objeto autocompletar
    let options = {
        data: objeto_regiones,
        getValue: "nombre",
        list: {
            maxNumberOfElements: 5,
            match: {
                enabled: true
            }
        },
        template: {
            type: "custom",
            method: function(value, objeto)
            {
            //  Crear div con el resultado
                let div     =   `<div class="box" onClick="consolidados_autocompletar_presidentes_asignar(${objeto.id})">
                                    <div class="child">${value}</div>
                                    <div class="parent">Región de Chile</div>
                                </div>`;

            //  Enviar resultado a la UI
                return div;
            }
        }
    };

//  Asignar funcionalidad
    $("#mesa_consolidado_comunas").easyAutocomplete(options);
}

// Funcionalidad autocompletar asignar
function consolidados_autocompletar_presidentes_asignar( id )
{
//  Obtener la Circunscripcion de la Comuna
    let region = objeto_regiones.find( obj => obj.id === id );

//  Tipo Zona Gobernador
    consolidado_zona = region.id;
    consolidado_zona_nombre = region.nombre;

//  Funcionalidad Botones nueva mesa
    const mensa_nueva_of = document.getElementById('mesa-nueva-of')
    const mensa_nueva_on = document.getElementById('mesa-nueva-on')

//  Estado de los botones
    mensa_nueva_of.style.display = 'none';
    mensa_nueva_on.style.display = 'block';
}

// Funcionalidad autocompletar
function consolidados_autocompletar_senadores()
{
//  Crear objeto autocompletar
    let options = {
        data: objeto_comunas,
        getValue: "nombre",
        list: {
            maxNumberOfElements: 5,
            match: {
                enabled: true
            }
        },
        template: {
            type: "custom",
            method: function(value, objeto)
            {
            //  Obtener Circunscripcion
                const circunscripcion = objeto_circunscripciones.find( obj => obj.id === objeto.circunscripcion );

            //  Crear div con el resultado
                let div     =   `<div class="box" onClick="consolidados_autocompletar_senadores_asignar(${objeto.id})">
                                    <div class="child">${value}</div>
                                    <div class="parent">${circunscripcion.nombre}</div>
                                </div>`;

            //  Enviar resultado a la UI
                return div;
            }
        }
    };

//  Asignar funcionalidad
    $("#mesa_consolidado_comunas").easyAutocomplete(options);
}

// Funcionalidad autocompletar asignar
function consolidados_autocompletar_senadores_asignar( id )
{
//  Obtener información de la Comuna
    const comuna = objeto_comunas.find( obj => obj.id === id );
    const circunscripcion = objeto_circunscripciones.find( obj => obj.id === comuna.circunscripcion );

//  Tipo Zona Alcalde
    consolidado_zona = circunscripcion.id;
    consolidado_zona_nombre = circunscripcion.nombre;

//  Funcionalidad Botones nueva mesa
    const mensa_nueva_of = document.getElementById('mesa-nueva-of')
    const mensa_nueva_on = document.getElementById('mesa-nueva-on')

//  Estado de los botones
    mensa_nueva_of.style.display = 'none';
    mensa_nueva_on.style.display = 'block';
}

// Funcionalidad autocompletar
function consolidados_autocompletar_diputados()
{
//  Crear objeto autocompletar
    let options = {
        data: objeto_comunas,
        getValue: "nombre",
        list: {
            maxNumberOfElements: 5,
            match: {
                enabled: true
            }
        },
        template: {
            type: "custom",
            method: function(value, objeto)
            {
            //  Obtener Circunscripcion
                const distrito = objeto_distritos.find( obj => obj.id === objeto.distrito );

            //  Crear div con el resultado
                let div     =   `<div class="box" onClick="consolidados_autocompletar_diputados_asignar(${objeto.id})">
                                    <div class="child">${value}</div>
                                    <div class="parent">${distrito.nombre}</div>
                                </div>`;

            //  Enviar resultado a la UI
                return div;
            }
        }
    };

//  Asignar funcionalidad
    $("#mesa_consolidado_comunas").easyAutocomplete(options);
}

// Funcionalidad autocompletar asignar
function consolidados_autocompletar_diputados_asignar( id )
{
//  Obtener información de la Comuna
    const comuna = objeto_comunas.find( obj => obj.id === id );
    const distrito = objeto_distritos.find( obj => obj.id === comuna.distrito );

//  Tipo Zona Alcalde
    consolidado_zona = distrito.id;
    consolidado_zona_nombre = distrito.nombre;

//  Funcionalidad Botones nueva mesa
    const mensa_nueva_of = document.getElementById('mesa-nueva-of')
    const mensa_nueva_on = document.getElementById('mesa-nueva-on')

//  Estado de los botones
    mensa_nueva_of.style.display = 'none';
    mensa_nueva_on.style.display = 'block';
}

// Validar el Estado de la accion
function consolidados_render_estado(estado)
{
    /*
    const consolidados_candidad_candidatos = document.getElementById('consolidados-candidad-candidatos');

    if( estado == 'on' )
    {
        consolidados_candidad_candidatos.style.opacity = 0.5;
    }
    else
    {
        consolidados_candidad_candidatos.style.opacity = 1;
    }


    const consolidados_render = document.getElementById('consolidados-render');
    const consolidados_render_icon = document.getElementById('consolidados-render-icon');

//  Validar los estados
    if( estado == 'on' )
    {
        consolidados_render.style.opacity = 0.5;
        consolidados_render.style.cursor = 'not-allowed';
        consolidados_render_icon.classList.remove('fa-highlighter');
        consolidados_render_icon.classList.add('fa-lock');
    }
    else
    {
        consolidados_render.style.opacity = 1;
        consolidados_render.style.cursor = 'pointer';
        consolidados_render_icon.classList.remove('fa-lock');
        consolidados_render_icon.classList.add('fa-highlighter');
    }
    */
}