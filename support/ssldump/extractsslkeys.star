def main():
        create_breakpoint({ "FunctionName": "crypto/tls.(*Config).writeKeyLog", "Line": -1 })
	while True:
		var1 = ""
		var2 = ""
		if dlv_command("continue") == None:
			var1 = eval(None, "clientRandom").Variable.Value
			var2 = eval(None, "secret").Variable.Value
			print(var1, " ", var2)
