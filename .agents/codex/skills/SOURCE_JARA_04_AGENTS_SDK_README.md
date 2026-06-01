# Agents SDK

Carril reservado para agentes consultivos de apoyo.

Estado inicial: `SYNTHETIC_ONLY`.

El primer agente debe:

- clasificar pedidos consultivos;
- proponer estructura de diagnostico;
- detectar sensibilidad o evidencia insuficiente;
- usar solo insumos sinteticos o publicables;
- escalar cuando aparezcan datos reales o decisiones no autorizadas.

## Smoke local

Modo fixture, sin API ni secretos:

```powershell
python 04_AGENTS_SDK\agent.py
```

Validador local:

```powershell
python 04_AGENTS_SDK\validate_synthetic_agent.py
```

Smoke API opcional, solo con prompt sintetico y una clave ya existente en el entorno:

```powershell
python 04_AGENTS_SDK\agent.py --api
```

No guardar claves, datos reales ni salidas de clientes en este repo.
