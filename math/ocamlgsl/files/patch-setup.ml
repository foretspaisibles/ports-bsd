--- setup.ml.orig	2013-07-30 08:09:40.000000000 +0200
+++ setup.ml	2013-07-30 08:09:46.000000000 +0200
@@ -5608,7 +5608,7 @@
             {
                pre_command = [(OASISExpr.EBool true, None)];
                post_command =
-                 [(OASISExpr.EBool true, Some (("make", ["post-conf"])))];
+                 [(OASISExpr.EBool true, Some (("gmake", ["post-conf"])))];
                };
           build_type = (`Build, "ocamlbuild", Some "0.3");
           build_custom =
