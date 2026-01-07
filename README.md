# simpleVHDL-CPU

## Getting started

### Prepaire snakemake

Snakemail is a simple tool for executing flows, similar to make.
See here: [https://snakemake.readthedocs.io/en/stable/](https://snakemake.readthedocs.io/en/stable/)

#### 1. Prepaire System

#### 2. Create Python-Enviroment

```console
$ python -m venv .venv
```

#### 3. Switch to Python-Enviroment

```console
$ source .venv/bin/activate
```

#### 4. Install snakemake

```console
(.venv)$ pip install snakemake
```

#### 5. Use snakemake

```console
(.venv)$ snakemake -f -p -c1 tb_cpu_v1.vcdgz
```

