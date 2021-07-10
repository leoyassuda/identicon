# Identicon

Given a string, the program generates a square avatar image with 250px size.

Sample:

<a href="https://imgbb.com/"><img src="https://i.ibb.co/9scrpN0/sample.png" alt="sample" width=125px border="0"></a>

## Repo example for Elixir

[![Hex version badge](https://img.shields.io/hexpm/v/repo_example.svg)](https://hex.pm/packages/repo_example)
[![License badge](https://img.shields.io/hexpm/l/repo_example.svg)](https://github.com/surgeventures/repo-example-elixir/blob/master/LICENSE.md)

## Run Locally

Clone the project

```bash
  git clone https://github.com/leoyassuda/identicon.git
```

Go to the project directory

```bash
  cd identicon
```

Install dependencies

```bash
  mix deps.get
```

Start iex

```bash
  iex -S mix
```

Execute passing a string as argument

```bash
  iex> Identicon.main "Leo"
```

Generate project documentation

```bash
  mix docs
```

Open in browser the file generated in docs folder `index.html`

## Run Tests

mix test

### Authors

* **Leo Yassuda** - *Initial work* - Portfolio [leoyas.com](https://leoyas.com)