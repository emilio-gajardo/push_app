# App: push_app

## Descripción: Aplicación creada en Flutter

## Instalación de dependencias:
1. equatable: ```flutter pub add equatable```

2. flutter_bloc: ```flutter pub add flutter_bloc```

3. go_router: ```flutter pub add go_router```

4. change_app_package_name: ```flutter pub add change_app_package_name``` [link documentacion](https://pub.dev/packages/change_app_package_name)


### Firebase:
5. firebase_messaging: ```flutter pub add firebase_messaging```

6. firebase_core: ```flutter pub add firebase_core```

7. firebase cli usando npm: ```npm install -g firebase-tools```

8. Validar versión instalada: ```firebase --version```

9. Login: ```firebase login```

10. Listar proyectos: ```firebase projects:list```

11. Activar flutterfire_cli global: ```dart pub global activate flutterfire_cli```

12. Seleccionar proyecto firebase: ```dart pub global run flutterfire_cli:flutterfire configure```


<br/><hr><br/>

# Configuraciones:
1. Para cambiar el id único de la app y el package name ejecutar:
    >```flutter pub run change_app_package_name:main com.nuevoNombre.push_app```

