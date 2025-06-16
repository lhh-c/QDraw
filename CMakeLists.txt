cmake_minimum_required(VERSION 3.31.2)

project(PaintApp LANGUAGES CXX)

# 查找Qt6库
find_package(Qt6 REQUIRED COMPONENTS Quick Widgets)

# 设置Qt6模块
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# 添加可执行文件
add_executable(PaintApp
    main.cpp
    # 这里后续可以添加C++源文件
)

# 添加资源文件
qt_add_resources(PaintApp "qml"
    PREFIX "/"
    FILES
        qml/MainWindow.qml
        qml/ToolPanel.qml
        qml/ColorPicker.qml
        qml/Canvas.qml
        qml/constants.js
)

# 链接Qt6库
target_link_libraries(PaintApp PRIVATE
    Qt6::Quick
    Qt6::Widgets
)

# 设置QML导入路径
target_compile_definitions(PaintApp PRIVATE
    QT_QML_DEBUG
)
