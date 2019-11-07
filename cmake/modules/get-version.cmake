cmake_minimum_required(VERSION 3.1.0)

set(VER_FILE ${PROJECT_SOURCE_DIR}/version)
set(DEFAULT_VER "1.4") #updated manually
unset(APP_VERSION)
unset(PSI_REVISION)
unset(PSI_PLUS_REVISION)
set(VERSION_OBTAINED OFF)

function(obtain_psi_version VERSION_LINES)
    set(_VLINES ${VERSION_LINES})
    string(REGEX MATCH "^[0-9]+\\.[0-9]+" _VER_LINE ${_VLINES})
    if(_VER_LINE)
        set(_APP_VERSION ${_VER_LINE})
        message(STATUS "Psi version found: ${_VER_LINE}")
    else()
        message(WARNING "Psi version not found! ${DEFAULT_VER} version will be set")
        set(_APP_VERSION ${DEFAULT_VER})
    endif()
    if(_APP_VERSION)
        set(APP_VERSION ${_APP_VERSION} PARENT_SCOPE)
        set(VERSION_OBTAINED ON PARENT_SCOPE)
    endif()
endfunction()

function(obtain_psi_plus_version VERSION_LINES)
    set(_VLINES ${VERSION_LINES})
    string(REGEX MATCHALL "^([0-9]+\\.[0-9]+\\.[0-9]+)+.+Psi:([a-fA-F0-9]+)+.+Psi\\+:([a-fA-F0-9]+)+" VER_LINE_A ${VER_LINES})
    if(${CMAKE_MATCH_COUNT} EQUAL 3)
        if(CMAKE_MATCH_1)
            set(_APP_VERSION ${CMAKE_MATCH_1})
        endif()
        if(CMAKE_MATCH_2)
            set(_PSI_REVISION ${CMAKE_MATCH_2})
        endif()
        if(CMAKE_MATCH_3)
            set(_PSI_PLUS_REVISION ${CMAKE_MATCH_3})
        endif()
    endif()
    if(_APP_VERSION)
        set(APP_VERSION ${_APP_VERSION} PARENT_SCOPE)
        message(STATUS "Psi version found: ${_APP_VERSION}")
    else()
        message(WARNING "Psi+ version not found! ${DEFAULT_VER} version will be set")
        set(APP_VERSION ${DEFAULT_VER} PARENT_SCOPE)
    endif()
    if(_PSI_REVISION)
        set(PSI_REVISION ${_PSI_REVISION} PARENT_SCOPE)
        message(STATUS "Psi revision found: ${_PSI_REVISION}")
    endif()
    if(_PSI_PLUS_REVISION)
        set(PSI_PLUS_REVISION ${_PSI_PLUS_REVISION} PARENT_SCOPE)
        message(STATUS "Psi+ revision found: ${_PSI_PLUS_REVISION}")
    endif()
    if(_APP_VERSION AND ( _PSI_REVISION AND _PSI_PLUS_REVISION ))
        set(VERSION_OBTAINED ON PARENT_SCOPE)
    endif()
endfunction()

if(NOT PSI_VERSION AND (EXISTS "${VER_FILE}"))
    message(STATUS "Found Psi version file: ${VER_FILE}")
    file(STRINGS "${VER_FILE}" VER_LINES)
    if(IS_PSIPLUS)
        obtain_psi_version("${VER_LINES}")
        #obtain_psi_plus_version("${VER_LINES}")
        if(VERSION_OBTAINED)
            #set(PSI_VERSION "${APP_VERSION} \(${PSI_COMPILATION_DATE}, Psi:${PSI_REVISION}, Psi+:${PSI_PLUS_REVISION}${PSI_VER_SUFFIX}\)")
            set(PSI_VERSION "${APP_VERSION} \(${PSI_COMPILATION_DATE}${PSI_VER_SUFFIX}\)")
        endif()
    else()
        obtain_psi_version("${VER_LINES}")
        if(VERSION_OBTAINED)
            if(PRODUCTION)
                set(PSI_VERSION "${APP_VERSION}")
            else()
                set(PSI_VERSION "${APP_VERSION} \(${PSI_COMPILATION_DATE}${PSI_VER_SUFFIX}\)")
            endif()
        endif()
    endif()
    unset(VER_LINES)
endif()

message(STATUS "${CLIENT_NAME} version set: ${PSI_VERSION}")
