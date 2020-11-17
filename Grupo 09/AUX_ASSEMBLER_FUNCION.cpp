verTope(&pila, cadena1);
		if(esOperadorBinario(cadena1)){
			printf("SOY OPERADOR BINARIO    %s\n",cadena1);
			if(strcmp(cadena1, "+") == 0){
				desapilar(&pila, aux2);
				desapilar(&pila, aux2);
				strcpy(aux, "FLD ");
				strcat(aux, aux2);
        		fprintf(af,"%s\n",aux);
        		desapilar(&pila, aux2);
				strcpy(aux, "FLD ");
				strcat(aux, aux2);
				fprintf(af,"%s\n",aux);
				fprintf(af,"FADD\n");
			}
			if(strcmp(cadena1, "-") == 0){
				desapilar(&pila, aux2);
				desapilar(&pila, aux2);
				strcpy(aux, "FLD ");
				strcat(aux, aux2);
        		fprintf(af,"%s\n",aux);
        		desapilar(&pila, aux2);
				strcpy(aux, "FLD ");
				strcat(aux, aux2);
				fprintf(af,"%s\n",aux);
				fprintf(af,"FSUB\n");
			}
		}
		if(esOperadorUnario(cadena1)){
			printf("SOY OPERADOR UNARIO    %s\n",cadena1);
		}
