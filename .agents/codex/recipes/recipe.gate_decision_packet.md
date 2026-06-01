# Recipe: Gate Decision Packet

1. Identify surface, identity, data class and requested action.
2. Classify as local, read-only remote, governed write, production or blocked.
3. Require rollback and postcheck for any governed write.
4. Produce `ALLOW_LOCAL`, `PREPARE_ORDER`, `BLOCK`, or `ESCALATE_HUMAN`.
5. Write evidence under `readbacks`.
