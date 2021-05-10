from cx_Freeze import Executable, setup

setup(
    name="build_test",
    version="0.0.1",
    maintainer="Deo",
    maintainer_email="kmc@gabia.com",
    description="build test",
    long_description="build test",
    options={
        "build_exe":{
            "zip_include_packages": ["*"],
            "zip_exclude_packages": [],
            "includes": [],
        }
    },
    packages=['build_test'],
    executables=[
        Executable(
            script="build_test/__main__.py",
            target_name="build_test",
            shortcut_name="build_test",
            shortcut_dir="build_test",
            copyright="©Gabia Inc. All Rights Reserved."
        )
    ],
    classifiers=[
        "Development Status :: 1 - Alpha",
        "Natural Language :: Korean",
        "Operating System :: OS Independent",
        "Programming Language :: Python :: 3.9",
    ],
    url="https://gitlab.gabia.com/gm1902888/build-test",
)
